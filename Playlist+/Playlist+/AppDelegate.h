//
//  AppDelegate.h
//  Playlist+
//
//  Created by Christopher Tetreault on 4/16/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//Singleton instances used by the app
@property (strong, nonatomic) NSMutableArray *thePlaylist;
@property (strong, nonatomic )MPMusicPlayerController *playlistPlayer;

@end
