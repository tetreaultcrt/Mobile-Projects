//
//  SettingsViewController.h
//  Minesweeper
//
//  Created by Christopher Tetreault on 3/17/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
- (IBAction)stepperChanged:(id)sender;
- (IBAction)sliderChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIStepper *stepperGameSize;
@property (strong, nonatomic) IBOutlet UIImageView *swatchImageView;
@property (strong, nonatomic) IBOutlet UISlider *sliderRed;
@property (strong, nonatomic) IBOutlet UISlider *sliderGreen;
@property (strong, nonatomic) IBOutlet UISlider *sliderBlue;
@property (strong, nonatomic) IBOutlet UILabel *gameSize;
@property (strong, nonatomic) NSNumber *gameSizeNumber;

@end
