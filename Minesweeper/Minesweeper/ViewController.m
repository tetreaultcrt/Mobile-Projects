//
//  ViewController.m
//  Minesweeper
//
//  Created by Christopher Tetreault on 2/11/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CellView.h"

@interface ViewController (){
    
    id gameGrid[16][16];
    int gameSize;
    double cellWidth;
    double cellHeight;
    int numberOfMines;
    int numberOfUnflaggedMines;
    AppDelegate *delegate;
    NSDate *startTime;
    NSTimeInterval timeInterval;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mines = [[NSMutableArray alloc] init];
    delegate = [[UIApplication sharedApplication] delegate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(updateTimerLabel)
                                                userInfo:nil
                                                 repeats:YES];
    
    gameSize = [delegate.persistentGameSize intValue];

    
    cellWidth =  320.0 / (double)gameSize;
    cellHeight = 474.0 / (double) gameSize;
    numberOfMines = (gameSize * gameSize) / 5;
    numberOfUnflaggedMines = 0;
    [self getMines];
    [self createGameGridWithMineArray];
    [self markNumberofAdjacentMines];
    
    self.unflaggedMinesLabel.text = [NSString stringWithFormat:@"%d", numberOfUnflaggedMines];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated{
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    CellView *cellView = gameGrid[0][0];
    
    if ([delegate.persistentGameSize intValue] != gameSize){
        
        gameSize = [delegate.persistentGameSize intValue];
        
        [self.mines removeAllObjects];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (UIView *subView in self.view.subviews){
            if ([subView isKindOfClass:[CellView class]]){
                [temp addObject:subView];
            }
        }
        [temp makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cellWidth =  320.0 / (double)gameSize;
        cellHeight = 474.0 / (double) gameSize;
        numberOfMines = (gameSize * gameSize) / 5;
        numberOfUnflaggedMines = 0;
        [self getMines];
        self.unflaggedMinesLabel.text = [NSString stringWithFormat:@"%d", numberOfUnflaggedMines];
        [self createGameGridWithMineArray];
        [self markNumberofAdjacentMines];
    } else if (delegate.cellColor != cellView.backgroundColor){
        [self.mines removeAllObjects];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (UIView *subView in self.view.subviews){
            if ([subView isKindOfClass:[CellView class]]){
                [temp addObject:subView];
            }
        }
        [temp makeObjectsPerformSelector:@selector(removeFromSuperview)];        cellWidth =  320.0 / (double)gameSize;
        [self getMines];
        [self createGameGridWithMineArray];
        [self markNumberofAdjacentMines];
    }
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getMines{
    
    for(int i = 0; i < numberOfMines; i++){
        int random = (arc4random() % (gameSize * gameSize));
        if ([self.mines indexOfObject:[NSNumber numberWithInt:random]] == NSNotFound){
            [self.mines addObject:[NSNumber numberWithInt:random]];
            numberOfUnflaggedMines++;
        }
    }
}

- (void) createGameGridWithMineArray{
    
    int i, j;
    
    for (i = 0; i < gameSize; i++){
        for (j = 0; j < gameSize; j++){
            
            CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(i*cellWidth, (j*cellHeight)+45, cellWidth, cellHeight)];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(singleTap:)];
            singleTap.numberOfTapsRequired = 1;
            [cell addGestureRecognizer:singleTap];
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            [cell addGestureRecognizer:doubleTap];
            
            [singleTap requireGestureRecognizerToFail:doubleTap];
            
            gameGrid[i][j] = cell;
            cell.iIndex = i;
            cell.jIndex = j;
            if ([self.mines indexOfObject:[NSNumber numberWithInt:((i*gameSize) + j) + 1]] != NSNotFound){
                cell.isMine = TRUE;
            } else{
                cell.isMine = FALSE;
            }
            [self.view addSubview:cell];
        }
    }
    
    startTime = [NSDate date];
}

-(void) singleTap:(UITapGestureRecognizer *)recognizer{
    
    CellView *cell = (CellView*)recognizer.view;
    if ([cell.indicator.text isEqualToString:@"F"]){
        cell.indicator.text = @" ";
        cell.isFlag = FALSE;
        
        if (cell.isMine){
            numberOfUnflaggedMines++;
        }
        
    } else if ([cell.indicator.text isEqualToString:@" "]){
        cell.indicator.text = @"F";
        cell.isFlag = TRUE;
        
        if (cell.isMine){
            numberOfUnflaggedMines--;
            self.unflaggedMinesLabel.text = [NSString stringWithFormat:@"%d", numberOfUnflaggedMines];
        }
    }
    
    [self checkIfWinner];

    
}

-(void) doubleTap:(UITapGestureRecognizer *)recognizer{
    
    CellView *cell = (CellView*)recognizer.view;
    
    if (cell.isMine) {
        [self showAllMines];
        cell.backgroundColor = [UIColor redColor];
        cell.indicator.text = @"M";
    } else if (cell.numberOfMinesNear > 0){
        cell.indicator.text = [NSString stringWithFormat:@"%d", cell.numberOfMinesNear];
        switch (cell.numberOfMinesNear) {
            case 1:
                cell.indicator.textColor = [UIColor blueColor];
                break;
            case 2:
                cell.indicator.textColor = [UIColor greenColor];
                break;
            case 3:
                cell.indicator.textColor = [UIColor redColor];
                break;
            case 4:
                cell.indicator.textColor = [UIColor purpleColor];
                break;
            case 5:
                cell.indicator.textColor = [UIColor yellowColor];
                break;
            case 6:
                cell.indicator.textColor = [UIColor orangeColor];
                break;
            default:
                cell.indicator.textColor = [UIColor blackColor];
                break;
        }
        cell.discovered = TRUE;
        cell.backgroundColor = [UIColor lightGrayColor];
    } else{
        [self depthFirstSearchFromCell:cell];
    }
    
    [self checkIfWinner];
}

-(void) showAllMines{
    
    int i, j;
    
    for (i = 0; i < gameSize; i++){
        for (j = 0; j < gameSize; j++){
            
            CellView *cell = gameGrid[i][j];
            if (cell.isMine){
                cell.indicator.text = @"M";
                cell.backgroundColor = [UIColor lightGrayColor];
            }
            
        }
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Lost!" message:@"Would you like to play again?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}

-(void) depthFirstSearchFromCell: (CellView*)cell{
    
    cell.discovered = TRUE;
    
    for (CellView *aCell in cell.adjacentCells){
        
        if (!aCell.discovered && aCell.numberOfMinesNear == 0){
            aCell.indicator.text = @" ";
            aCell.backgroundColor = [UIColor lightTextColor];
            [self depthFirstSearchFromCell:aCell];
        } else{
            
            
            if (aCell.isMine){
                aCell.indicator.text = @" ";
                aCell.backgroundColor = [UIColor lightGrayColor];
                aCell.discovered = TRUE;
            } else if (aCell.numberOfMinesNear > 0){
                aCell.indicator.text = [NSString stringWithFormat:@"%d", aCell.numberOfMinesNear];
                
                switch (aCell.numberOfMinesNear) {
                    case 1:
                        aCell.indicator.textColor = [UIColor blueColor];
                        break;
                    case 2:
                        aCell.indicator.textColor = [UIColor greenColor];
                        break;
                    case 3:
                        aCell.indicator.textColor = [UIColor redColor];
                        break;
                    case 4:
                        aCell.indicator.textColor = [UIColor purpleColor];
                        break;
                    case 5:
                        aCell.indicator.textColor = [UIColor yellowColor];
                        break;
                    case 6:
                        aCell.indicator.textColor = [UIColor orangeColor];
                        break;
                    default:
                        aCell.indicator.textColor = [UIColor blackColor];
                        break;
                }
                
                aCell.backgroundColor = [UIColor lightGrayColor];
                aCell.discovered = TRUE;
            } else {
                aCell.indicator.text = @" ";
                aCell.backgroundColor = [UIColor lightTextColor];
                aCell.discovered = TRUE;
            }
            
            
        }
    }
    
    
}

- (void) checkIfWinner{
    
    if (numberOfUnflaggedMines == 0){
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *storedHighScore = [defaults objectForKey:@"highScore"];
        
        if ([storedHighScore isEqualToString:@""]){
            return;
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *storedHS =[formatter numberFromString:storedHighScore];
        
        NSNumber *currentScore = [NSNumber numberWithDouble:timeInterval];
        
        if (currentScore < storedHS){
            [defaults setObject:[currentScore stringValue] forKey:@"highScore"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won and Beat Your Best Time!" message:@"Would you like to play again?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won!" message:@"Would you like to play again?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
        
    } else {
        
        for (int i = 0; i < gameSize; i++){
            for (int j = 0; j < gameSize; j++){
                CellView *cellView = gameGrid[i][j];
                
                if (cellView.isMine && !cellView.discovered){
                    return;
                }
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won!" message:@"Would you like to play again?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        
        [alert show];
        
        
        
    }
    
}


- (void) markNumberofAdjacentMines{
    
    int i, j;
    
    for (i = 0; i < gameSize; i++){
        for (j = 0; j < gameSize; j++){
            
            CellView *cell = gameGrid[i][j];

            
            if (i == 0 && j == 0){
                
                CellView *adjCell1 = gameGrid[i][j+1];
                CellView *adjCell2 = gameGrid[i+1][j+1];
                CellView *adjCell3 = gameGrid[i+1][j];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                
            } else if (i == 0 && j == gameSize - 1){
                
                CellView *adjCell1 = gameGrid[i][j-1];
                CellView *adjCell2 = gameGrid[i+1][j];
                CellView *adjCell3 = gameGrid[i+1][j-1];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if(adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                
            } else if (i == gameSize - 1 && j == 0){
                
                CellView *adjCell1 = gameGrid[i-1][j];
                CellView *adjCell2 = gameGrid[i-1][j+1];
                CellView *adjCell3 = gameGrid[i][j+1];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
   
            } else if (i == gameSize - 1 && j == gameSize - 1){
                
                
                CellView *adjCell1 = gameGrid[i-1][j];
                CellView *adjCell2 = gameGrid[i-1][j-1];
                CellView *adjCell3 = gameGrid[i][j-1];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
 
            } else if (i == 0){
                
                
                CellView *adjCell1 = gameGrid[i][j-1];
                CellView *adjCell2 = gameGrid[i+1][j-1];
                CellView *adjCell3 = gameGrid[i+1][j];
                CellView *adjCell4 = gameGrid[i+1][j+1];
                CellView *adjCell5 = gameGrid[i][j+1];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell4.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell5.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                [cell.adjacentCells addObject:adjCell4];
                [cell.adjacentCells addObject:adjCell5];
   
            } else if (i == gameSize - 1){
                
                CellView *adjCell1 = gameGrid[i][j-1];
                CellView *adjCell2 = gameGrid[i-1][j-1];
                CellView *adjCell3 = gameGrid[i-1][j];
                CellView *adjCell4 = gameGrid[i-1][j+1];
                CellView *adjCell5 = gameGrid[i][j+1];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell4.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell5.isMine){
                    cell.numberOfMinesNear++;
                }

                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                [cell.adjacentCells addObject:adjCell4];
                [cell.adjacentCells addObject:adjCell5];
                
            } else if (j == 0){
                
                
                CellView *adjCell1 = gameGrid[i-1][j];
                CellView *adjCell2 = gameGrid[i-1][j+1];
                CellView *adjCell3 = gameGrid[i][j+1];
                CellView *adjCell4 = gameGrid[i+1][j+1];
                CellView *adjCell5 = gameGrid[i+1][j];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell4.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell5.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                [cell.adjacentCells addObject:adjCell4];
                [cell.adjacentCells addObject:adjCell5];
 
                
            } else if (j == gameSize - 1){
                
                CellView *adjCell1 = gameGrid[i-1][j];
                CellView *adjCell2 = gameGrid[i-1][j-1];
                CellView *adjCell3 = gameGrid[i][j-1];
                CellView *adjCell4 = gameGrid[i+1][j-1];
                CellView *adjCell5 = gameGrid[i+1][j];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell4.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell5.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                [cell.adjacentCells addObject:adjCell4];
                [cell.adjacentCells addObject:adjCell5];
 
            } else{
                
                CellView *adjCell1 = gameGrid[i-1][j-1];
                CellView *adjCell2 = gameGrid[i-1][j];
                CellView *adjCell3 = gameGrid[i-1][j+1];
                CellView *adjCell4 = gameGrid[i][j-1];
                CellView *adjCell5 = gameGrid[i][j+1];
                CellView *adjCell6 = gameGrid[i+1][j-1];
                CellView *adjCell7 = gameGrid[i+1][j];
                CellView *adjCell8 = gameGrid[i+1][j+1];
                
                if (adjCell1.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell2.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell3.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell4.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell5.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell6.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell7.isMine){
                    cell.numberOfMinesNear++;
                }
                if (adjCell8.isMine){
                    cell.numberOfMinesNear++;
                }
                
                [cell.adjacentCells addObject:adjCell1];
                [cell.adjacentCells addObject:adjCell2];
                [cell.adjacentCells addObject:adjCell3];
                [cell.adjacentCells addObject:adjCell4];
                [cell.adjacentCells addObject:adjCell5];
                [cell.adjacentCells addObject:adjCell6];
                [cell.adjacentCells addObject:adjCell7];
                [cell.adjacentCells addObject:adjCell8];

 
            }
 
        }
    }  
    
}

//alertview delegate protocol method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self resetGame:self];

    
}

- (IBAction)resetGame:(id)sender {
    
    [self.mines removeAllObjects];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (UIView *subView in self.view.subviews){
        if ([subView isKindOfClass:[CellView class]]){
            [temp addObject:subView];
        }
    }
    [temp makeObjectsPerformSelector:@selector(removeFromSuperview)];
    numberOfUnflaggedMines = 0;
    [self getMines];
    self.unflaggedMinesLabel.text = [NSString stringWithFormat:@"%d", numberOfUnflaggedMines];
    [self createGameGridWithMineArray];
    [self markNumberofAdjacentMines];
}

-(void) updateTimerLabel{
    
    timeInterval = [startTime timeIntervalSinceNow];
    
    self.timerLabel.text = [NSString stringWithFormat:@"%.2f", -timeInterval];
    
    
}
@end
