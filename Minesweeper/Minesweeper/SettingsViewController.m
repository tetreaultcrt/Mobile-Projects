//
//  SettingsViewController.m
//  Minesweeper
//
//  Created by Christopher Tetreault on 3/17/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"

@interface SettingsViewController (){
    AppDelegate *delegate;
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate = [[UIApplication sharedApplication] delegate];
    [self.swatchImageView setBackgroundColor:[UIColor colorWithRed:self.sliderRed.value green:self.sliderGreen.value blue:self.sliderBlue.value alpha:1.0]];
    self.stepperGameSize.value = [delegate.persistentGameSize floatValue];
    self.gameSize.text = [NSString stringWithFormat:@"%d", (int)self.stepperGameSize.value];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperChanged:(id)sender {
    self.gameSize.text = [NSString stringWithFormat:@"%d", (int)self.stepperGameSize.value];
    delegate.persistentGameSize = [NSNumber numberWithInteger:(int)self.stepperGameSize.value];
    
}
- (IBAction)sliderChanged:(id)sender {
    [self.swatchImageView setBackgroundColor:[UIColor colorWithRed:self.sliderRed.value green:self.sliderGreen.value blue:self.sliderBlue.value alpha:1.0]];
    delegate.cellColor = [UIColor colorWithRed:self.sliderRed.value green:self.sliderGreen.value blue:self.sliderBlue.value alpha:1.0];
}
@end
