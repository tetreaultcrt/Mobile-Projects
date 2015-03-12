//
//  PlayListTableViewController.m
//  Playlist+
//
//  Created by Christopher Tetreault on 4/30/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import "PlayListTableViewController.h"
#import "AppDelegate.h"

@interface PlayListTableViewController (){
    AppDelegate *delegate;
    
}

@end

@implementation PlayListTableViewController


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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Adjust TableView background and view settings
    self.songListTableView.backgroundColor = [UIColor blackColor];
    [self.songListTableView.layer setOpacity:.8];
    
    [self.songListTableView setSeparatorInset:UIEdgeInsetsZero];
    
    //Create Background Blur
    UIImageView *personalImageView = (UIImageView*)[self.view viewWithTag:1000];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"thewar2.jpg"].CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    personalImageView.image = returnImage;
    [personalImageView.layer setOpacity:.7];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//Provide data and specs for tableView containing the playlist
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [delegate.thePlaylist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell Identifier" forIndexPath:indexPath];
    
    
    UILabel *songArtist = (UILabel*)[cell viewWithTag:1];
    UILabel *songName = (UILabel*)[cell viewWithTag:2];
    UILabel *songLength = (UILabel*)[cell viewWithTag:3];
    UIImageView *songAlbum = (UIImageView*)[cell viewWithTag:5];
    MPMediaItem *item = [delegate.thePlaylist objectAtIndex:indexPath.row];
    

    songArtist.text = [item valueForProperty:MPMediaItemPropertyAlbumArtist];
    songName.text = [item valueForProperty:MPMediaItemPropertyTitle];
    
    UIImage *artistImage = [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(60.0, 60.0)];
    songAlbum.image = artistImage;
    NSNumber *duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSNumber *minutes = [NSNumber  numberWithInt:[duration intValue] / 60];
    NSNumber *seconds = [NSNumber  numberWithInt:[duration intValue] - ([minutes intValue] * 60)];

    if ([seconds intValue] < 10){
        songLength.text = [NSString stringWithFormat:@"%@:0%@", minutes, seconds];
    } else{
        songLength.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    }
    
    cell.layer.opacity = .8;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItem *item = [delegate.thePlaylist objectAtIndex:indexPath.row];
    [delegate.playlistPlayer setNowPlayingItem:item];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark IBActions
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
