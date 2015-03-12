//
//  MusicPlayerViewController.m
//  Playlist+
//
//  Created by Christopher Tetreault on 4/29/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "PlayListTableViewController.h"
#import "AppDelegate.h"

@interface MusicPlayerViewController (){
    
    AppDelegate *delegate;
    BOOL playing;
    MPMediaItem *nowPlaying;
    NSTimeInterval currentTime;
    MPVolumeView *volumeView;

}

@end

@implementation MusicPlayerViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    self  = [super initWithCoder:aDecoder];
    if (self){
        delegate = [UIApplication sharedApplication].delegate;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create Volume Slider
    volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(20, 460, 290, 20)];
    [self.view addSubview:volumeView];
    
    //Create Blur for Background
    UIImageView *personalImageView = (UIImageView*)[self.view viewWithTag:1000];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"graffiti1.jpg"].CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    personalImageView.image = returnImage;
    [personalImageView.layer setOpacity:.7];
    
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1001];
    [imageView.layer setOpacity:.7];
    
    
    //If Playlist changed, use new Collection for playlist player, else don't
    if (self.playlistChanged){
        MPMediaItemCollection* playlistCollection = [MPMediaItemCollection collectionWithItems:delegate.thePlaylist];
        delegate.playlistPlayer = [MPMusicPlayerController iPodMusicPlayer];
        [delegate.playlistPlayer setQueueWithItemCollection:playlistCollection];
        
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handle_NowPlayingItemChanged:)
         name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
         object:      delegate.playlistPlayer];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handle_PlaybackStateChanged:)
         name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
         object:      delegate.playlistPlayer];
        
        [delegate.playlistPlayer beginGeneratingPlaybackNotifications];
        
        [delegate.playlistPlayer play];

        
        self.nowPlayingImgView.image = [[[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(320, 335)];
        playing = YES;
        
        self.songNameLabel.text = [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
        self.artistInfoLabel.text = [NSString stringWithFormat:@"%@ - %@", [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumArtist], [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];
    } else {
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handle_NowPlayingItemChanged:)
         name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
         object:      delegate.playlistPlayer];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handle_PlaybackStateChanged:)
         name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
         object:      delegate.playlistPlayer];
        
        [delegate.playlistPlayer beginGeneratingPlaybackNotifications];
        
        self.nowPlayingImgView.image = [[[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(320, 335)];
        playing = YES;
        
        self.songNameLabel.text = [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
        self.artistInfoLabel.text = [NSString stringWithFormat:@"%@ - %@", [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumArtist], [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];


    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Optional method call invoked by notifications that could be used for an applicationMusicPlayer, generally not needed as of now
- (void) handle_PlaybackStateChanged: (id) notification {


	MPMusicPlaybackState playbackState = [delegate.playlistPlayer playbackState];

	if (playbackState == MPMusicPlaybackStatePaused) {
        
		
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
        
        
        
	} else if (playbackState == MPMusicPlaybackStateStopped) {

        
	}
}

//Update UI when nowPlayingItem changes in the iPodMusicPlayer
- (void) handle_NowPlayingItemChanged: (id) notification {
    
	
    self.songNameLabel.text = [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
    
    if ([[[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle] length] == 0){
        self.artistInfoLabel.text = [NSString stringWithFormat:@"%@", [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumArtist]];
    } else {
        self.artistInfoLabel.text = [NSString stringWithFormat:@"%@ - %@", [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumArtist], [[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];
    }
    
    
    self.nowPlayingImgView.image = [[[delegate.playlistPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(320, 335)];
    

    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"modalToSongList"]) {
        
    }
}

#pragma mark - Player Control IBActions
- (IBAction)playPauseButtonPressed:(id)sender {
    if (playing){
        [delegate.playlistPlayer pause];
        playing = NO;
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"download (1).png"] forState:UIControlStateNormal];
    } else {
        [delegate.playlistPlayer play];
        playing = YES;
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"download (2).png"] forState:UIControlStateNormal];
    }
}

- (IBAction)skipForwardButtonPressed:(id)sender {
    [delegate.playlistPlayer skipToNextItem];

}
- (IBAction)skipBackButtonpressed:(id)sender {
    [delegate.playlistPlayer skipToPreviousItem];
}
@end
