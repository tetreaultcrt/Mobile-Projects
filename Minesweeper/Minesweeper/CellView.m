//
//  CellView.m
//  Minesweeper
//
//  Created by Christopher Tetreault on 2/11/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import "AppDelegate.h"
#import "CellView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CellView{
    AppDelegate *delegate;
}

@synthesize isFlag;
@synthesize isMine;
@synthesize numberOfMinesNear;
@synthesize indicator;
@synthesize adjacentCells;

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self){
        delegate = [[UIApplication sharedApplication] delegate];
        [self setUpView];
        self.adjacentCells = [[NSMutableArray alloc] init];

    }
    return self;
    
}

- (void) setUpView{
    
    
    self.backgroundColor = delegate.cellColor;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.3f;
    
    indicator = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 16, 22)];
    
    indicator.text = @" ";
    
    
    [self addSubview:indicator];
    
}


@end
