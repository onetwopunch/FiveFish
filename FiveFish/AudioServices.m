//
//  AudioServices.m
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "AudioServices.h"
#import "DataAccessLayer.h"
#import "AudioTrack.h"
#import "VideoTrack.h"
#import "Program.h"

@implementation AudioServices
@synthesize player, tracksToBePlayed, samplePlayer;


-(void)setProgram:(NSInteger)gid{
    program = [DataAccessLayer getProgramById:gid];
    tracksToBePlayed = [[NSMutableArray alloc] initWithArray: [DataAccessLayer getSortedTracks:program]];
}


-(NSURL*)getTrackUrl:(NSString *)track{
    int gid = [program.grn_id intValue];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * p = [NSString stringWithFormat:@"audio/%05d/%@", gid, track];
    NSString *trackPath = [documentsDirectory stringByAppendingPathComponent:p];
    
    NSURL * url = [NSURL fileURLWithPath:trackPath];
    if (self.tracksToBePlayed == nil) {
        self.tracksToBePlayed = [[NSMutableArray alloc] init];
        currentTrackIdx = 0;
    }
    return url;
}
-(NSString*) getPicturePath:(NSString*) picture{
    int gid = [program.grn_id intValue];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * p = [NSString stringWithFormat:@"pictures/%05d/%@", gid, picture];
    NSString *picPath = [documentsDirectory stringByAppendingPathComponent:p];
    return picPath;
}
-(BOOL)isPlaying{
    return player.isPlaying;
}
-(BOOL)prepareToPlay {
    NSError * error;
    AudioTrack *track = [tracksToBePlayed objectAtIndex:currentTrackIdx];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getTrackUrl:track.file] error:&error];
    [player setDelegate:self];
    return [player prepareToPlay];
}
-(void)playCurrentTrack{
    if (!player) {
        [self prepareToPlay];
        [player play];
    }else{
        [player play];
    }
}
-(void)pauseCurrentTrack{
    [player pause];
}
-(void)stop{
    [player stop];
    player.currentTime = 0;
    [player prepareToPlay];
}
-(void)setVolume:(float) volume{
    [player setVolume:volume];
}
-(void)nextTrack{
    [player stop];
    player = nil;
    if (currentTrackIdx == [tracksToBePlayed count]-1) {
        currentTrackIdx = 0;
        [self playCurrentTrack];
    } else {
        currentTrackIdx++;
        [self playCurrentTrack];
    }
}

-(void)previousTrack{
    [player stop];
    player = nil;
    if (currentTrackIdx == 0) {
        [self playCurrentTrack];
    } else {
        currentTrackIdx --;
        [self playCurrentTrack];
    }
}
-(NSString*)getProgramTitle{
    return program.title;
}

-(NSString*)getTrackTitle {
    AudioTrack *track = [tracksToBePlayed objectAtIndex:currentTrackIdx];
    return track.title;
}
-(UIImage*)getCurrentImage{
    AudioTrack *track = [tracksToBePlayed objectAtIndex:currentTrackIdx];
    NSString* path = [self getPicturePath:track.picture];
    return [UIImage imageWithContentsOfFile:path];
}
-(NSString *)getYoutubeUrl{
    @try {
        return program.videoTrack.reference;
    }
    @catch (NSException *exception) {
        return nil;
    }    
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Track finished: successfully=%@", flag ? @"YES"  : @"NO");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TrackFinishedSuccessfully" object:[NSNumber numberWithBool:flag]];

}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Audio Playback Error=%@", error);
}

@end
