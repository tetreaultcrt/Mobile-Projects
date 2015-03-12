//
//  AppDelegate.h
//  Minesweeper
//
//  Created by Christopher Tetreault on 2/11/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSNumber *persistentGameSize;
@property (strong, nonatomic) UIColor *cellColor;

@end
