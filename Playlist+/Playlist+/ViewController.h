//
//  ViewController.h
//  Playlist+
//
//  Created by Christopher Tetreault on 4/16/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

//Referencing Outlets
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nowPlayingBarBttn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UICollectionView *artistsCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *albumArrowImageView;

//IBActions
- (IBAction)generatePlaylist:(id)sender;
- (IBAction)clearSelectedArtists:(id)sender;

@end
