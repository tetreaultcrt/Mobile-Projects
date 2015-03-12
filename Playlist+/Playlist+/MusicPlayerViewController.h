//
//  MusicPlayerViewController.h
//  Playlist+
//
//  Created by Christopher Tetreault on 4/29/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicPlayerViewController : UIViewController

//IBActions
- (IBAction)playPauseButtonPressed:(id)sender;
- (IBAction)skipForwardButtonPressed:(id)sender;
- (IBAction)skipBackButtonpressed:(id)sender;
//Referencing Outlets
@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistInfoLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIImageView *nowPlayingImgView;
//Properties
@property (nonatomic) BOOL playlistChanged;

@end
