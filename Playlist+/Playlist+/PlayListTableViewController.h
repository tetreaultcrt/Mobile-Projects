//
//  PlayListTableViewController.h
//  Playlist+
//
//  Created by Christopher Tetreault on 4/30/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PlayListTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
//Referencing Outlets
@property (strong, nonatomic) IBOutlet UITableView *songListTableView;
//IBActions
- (IBAction)doneButtonPressed:(id)sender;

@end
