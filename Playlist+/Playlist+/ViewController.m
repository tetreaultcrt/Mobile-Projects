//
//  ViewController.m
//  Playlist+
//
//  Created by Christopher Tetreault on 4/16/14.
//  Copyright (c) 2014 Christopher Tetreault. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayerViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController (){
    NSArray *artistsCollection;
    NSString *artist1;
    NSString *artist2;
    NSString *artist3;
    NSMutableArray *selectedArtists;
    NSMutableArray *recommendedArtists;
    NSMutableArray *songBank;
    NSMutableArray *playlist;
    BOOL newPlaylist;
    
}
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initializations
    selectedArtists = [[NSMutableArray alloc] init];
    recommendedArtists = [[NSMutableArray alloc] init];
    songBank = [[NSMutableArray alloc] init];
    
    //Changing views color/opacity
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.translucent = NO;
    self.artistsCollectionView.backgroundColor = [UIColor blackColor];
    [self.artistsCollectionView.layer setOpacity:.8];
    
    
    //Create background blur
    UIImageView *wholeBackgroundImage = (UIImageView*)[self.view viewWithTag:1000];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"graffiti2.jpg"].CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    

    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    wholeBackgroundImage.image = returnImage;
    [wholeBackgroundImage.layer setOpacity:.6];
    
    
    //Grab artists from local media
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query setGroupingType:MPMediaGroupingAlbumArtist];
    artistsCollection = [query collections];
  
}


- (void) viewWillAppear:(BOOL)animated {
    
    //To make sure they can't go to now playing when nothing is playing
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    if ([delegate.thePlaylist count] == 0){
        self.nowPlayingBarBttn.enabled = NO;
    } else {
        self.nowPlayingBarBttn.enabled = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collection View methods
//Provides Data and specification for the Collection View and Collection view cells
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {

    return [artistsCollection count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";

    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
        
    }
    
    MPMediaItemCollection *collection = [artistsCollection objectAtIndex:indexPath.row];
    NSArray *Artists = [collection items];
    MPMediaItem *mediaItem = [Artists objectAtIndex:0];
    UIImage *artistImage = [[mediaItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(110.0, 110.0)];
    UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:100];
    cellImageView.image = artistImage;
    UILabel *artistLabel = (UILabel*)[cell viewWithTag:200];
    artistLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
    
    
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItemCollection *collection = [artistsCollection objectAtIndex:indexPath.row];
    NSArray *Artists = [collection items];
    MPMediaItem *mediaItem = [Artists objectAtIndex:0];
    
    if ([artist1 length] == 0){
        artist1 = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:1];
        imgView.image = [[mediaItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(90.0, 90.0)];
        imgView.hidden = NO;
        UILabel *label = (UILabel*)[self.view viewWithTag:4];
        label.text = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        label.hidden = NO;
        [selectedArtists insertObject:artist1 atIndex:0];
        //animate arrow
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.albumArrowImageView setFrame:CGRectMake(148, 177, self.albumArrowImageView.frame.size.width, self.albumArrowImageView.frame.size.height)];
                         }
                         completion:nil];
    } else if ([artist2 length] == 0){
        artist2 = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:2];
        imgView.image = [[mediaItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(90.0, 90.0)];
        imgView.hidden = NO;
        UILabel *label = (UILabel*)[self.view viewWithTag:5];
        label.text = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        label.hidden = NO;
        [selectedArtists insertObject:artist2 atIndex:1];
        //animate arrow
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.albumArrowImageView setFrame:CGRectMake(243, 177, self.albumArrowImageView.frame.size.width, self.albumArrowImageView.frame.size.height)];
                         }
                         completion:nil];
    } else if ([artist3 length] == 0){
        artist3 = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:3];
        imgView.image = [[mediaItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(90.0, 90.0)];
        imgView.hidden = NO;
        UILabel *label = (UILabel*)[self.view viewWithTag:6];
        label.text = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        label.hidden = NO;
        [selectedArtists insertObject:artist3 atIndex:2];
    } else {
        //available for something
    }
    
    
}

#pragma mark Playlist Creation methods
//Begins asynchronous task of fetching data from Last.fm API while displaying an activity indicator
- (IBAction)generatePlaylist:(id)sender {
    
    [self.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    for (NSString *artist in selectedArtists){
        
        //last.fm url
        NSString *url = [NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=%@&api_key=3ec669586c138efe1f51900eb2f06418&format=json&limit=100&autocorrect[0|1]", artist];

        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *actualURL = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:actualURL];

        //fetch Last.fm data in JSON FORM
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
        
        //Add actual artists music to songBank as well.
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyAlbumArtist]];
        
        NSArray *songsForArtist = [query items];
        [songBank addObjectsFromArray:songsForArtist];
        
        
        }
        
        [self makePlaylist];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityIndicator stopAnimating];
            NSLog(@"Finished with playlist: %lu", (unsigned long)[playlist count]);
            [self performSegueWithIdentifier:@"pushToPlayer" sender:self];
        });
    });
    
}
//Parse JSON for List of similar artists. Check Local library for artist and add to Songbank
-(void) fetchedData: (NSData*) responseData{
    
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if (json) {
        
        NSDictionary *similarartists = [json objectForKey:@"similarartists"];
        
        NSArray *ArrayofArtists = [similarartists objectForKey:@"artist"];
        
        for (NSDictionary *artist in ArrayofArtists) {
            
            NSString *similarArtist = [artist objectForKey:@"name"];
            
            MPMediaQuery *query = [[MPMediaQuery alloc] init];
            [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:similarArtist forProperty:MPMediaItemPropertyAlbumArtist]];
            
            NSArray *songsForArtist = [query items];
            
            if ([songsForArtist count] != 0){
                
                [songBank addObjectsFromArray:songsForArtist];
            }
        }
        
    }
    
}
//Actually create the playlist array based on randomly selecting 50 songs from the SongBank
- (void)makePlaylist{
    
    playlist = [[NSMutableArray alloc] initWithCapacity:50];
    
    
    if ([songBank count] >= 50){
        
        for (int i = 0; i < 50; i++){
            int randomIndex = rand() % [songBank count];
            
            if ([playlist indexOfObject:[songBank objectAtIndex:randomIndex]] == NSNotFound){
                [playlist addObject:[songBank objectAtIndex:randomIndex]];
            } else {
                i--;
            }
        }
        
    } else {
        
        for (int i = 0; i < [songBank count]; i++){
            [playlist addObject:[songBank objectAtIndex:i]];
        }
        
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.thePlaylist removeAllObjects];
    appDelegate.thePlaylist = playlist;
    
    newPlaylist = YES;
    
}

#pragma mark IBActions
//clear the three options to allow for 3 new ones
- (IBAction)clearSelectedArtists:(id)sender {
    
    
    [selectedArtists removeAllObjects];
    artist1 = nil;
    artist2 = nil;
    artist3 = nil;
    UIImageView *imageView1 = (UIImageView*)[self.view viewWithTag:1];
    UIImageView *imageView2 = (UIImageView*)[self.view viewWithTag:2];
    UIImageView *imageView3 = (UIImageView*)[self.view viewWithTag:3];
    imageView1.hidden = YES;
    imageView2.hidden = YES;
    imageView3.hidden = YES;
    
    UILabel *label4 = (UILabel*)[self.view viewWithTag:4];
    UILabel *label5 = (UILabel*)[self.view viewWithTag:5];
    UILabel *label6 = (UILabel*)[self.view viewWithTag:6];
    label4.hidden = YES;
    label5.hidden = YES;
    label6.hidden = YES;
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.albumArrowImageView setFrame:CGRectMake(53, 177, self.albumArrowImageView.frame.size.width, self.albumArrowImageView.frame.size.height)];
                     }
                     completion:nil];
    
}



#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"pushToPlayer"]) {
        MusicPlayerViewController *aVC = (MusicPlayerViewController*)segue.destinationViewController;
        aVC.playlistChanged = newPlaylist;
        
    }
}


@end
