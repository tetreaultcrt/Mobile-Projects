//
//  CellView.h
//  Minesweeper
//
//  Created by Christopher Tetreault on 2/11/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView

@property BOOL isMine;
@property BOOL isFlag;
@property BOOL discovered;
@property int numberOfMinesNear;
@property (strong, nonatomic) UILabel *indicator;
@property (strong, nonatomic) NSMutableArray *adjacentCells;
@property int iIndex;
@property int jIndex;

@end
