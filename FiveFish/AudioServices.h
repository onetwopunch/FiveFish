//
//  AudioServices.h
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVPlayer.h>
#import "Program.h"

@interface AudioServices : NSObject <AVAudioPlayerDelegate>
{
    int currentTrackIdx;
    Program *program;
}
/*
 The player property is the one and only AVAudioPlayer managed by the service. If a new track is loaded, the player will be reinitialized. It is effectively a Singleton, however it needs to be instantiated with different requirements in different places 
 */
@property (strong, nonatomic) AVAudioPlayer * player;

/*
 The samplePlayer property is used to play the samples in LanguagesViewController. AVAudioPlayer did not work for streaming, which is why AVPlayer is used.
 */
@property (strong, nonatomic) AVPlayer * samplePlayer;

/*
 We keep track of each of the AudioTracks as objects in this array. These are all the tracks in the program ordered by their file's name.
 */
@property (strong, nonatomic) NSMutableArray * tracksToBePlayed;


/*
 These methods provide the AudioHelper with access to the functionality of the AVAudioPlayer and the data of the tracksToBePlayed queue.
 */
-(NSURL*)getTrackUrl:(NSString *)track;
-(NSString *)getYoutubeUrl;
-(BOOL)isPlaying;
-(void)setProgram:(NSInteger)gid;
-(BOOL)prepareToPlay;
-(void)playCurrentTrack;
-(void)pauseCurrentTrack;
-(void)stop;
-(void)setVolume:(float) volume;
-(void)nextTrack;
-(void)previousTrack;
-(NSString*)getProgramTitle;
-(NSString*)getTrackTitle;
-(UIImage*)getCurrentImage;
@end
