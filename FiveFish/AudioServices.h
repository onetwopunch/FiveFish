//
//  AudioServices.h
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "Program.h"

@interface AudioServices : NSObject <AVAudioPlayerDelegate>
{
    int currentTrackIdx;
    Program *program;
}
@property (strong, nonatomic) AVAudioPlayer * player;
@property (strong, nonatomic) NSMutableArray * tracksToBePlayed;

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
