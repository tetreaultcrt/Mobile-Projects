//
//  ViewController.h
//  Minesweeper
//
//  Created by Christopher Tetreault on 2/11/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *mines;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
- (IBAction)resetGame:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *unflaggedMinesLabel;

@end
