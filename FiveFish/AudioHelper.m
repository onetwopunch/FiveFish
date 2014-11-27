//
//  AudioHelper.m
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "AudioHelper.h"
#import "DataAccessLayer.h"
#import "Program.h"
#import "AudioTrack.h"
#import <AVFoundation/AVPlayerItem.h>
#import <CoreMedia/CMTime.h>

@implementation AudioHelper
@synthesize audioServices;


-(id)init{
    self = [super init];
    if(self){
        audioServices = [[AudioServices alloc] init];
        currentLanguageSample = 0;
    }
    return self;
}
-(void)queueTracksForProgramId:(NSInteger)gid{
    [audioServices setProgram:gid];
}

-(void)prepareToPlay{
    [audioServices prepareToPlay];
}

-(void)play{
    [audioServices playCurrentTrack];
}
-(void)pause{
    [audioServices pauseCurrentTrack];
}
-(void)stop{
    [audioServices stop];
}
-(void)next{
    [audioServices nextTrack];
}
-(void)previous{
    [audioServices previousTrack];
}
-(void)volume:(float)vol{
    [audioServices setVolume:vol];
}
-(void)setCurrentTime:(float)val{
    audioServices.player.currentTime = val;
}
-(float) getCurrentTimeValue{
    return audioServices.player.currentTime;
}
-(NSString*)getCurrentTime{
    int time =  (int)audioServices.player.currentTime;
    if(time < 60){
        return [NSString stringWithFormat:@"0:%02d", time];
    }else {
        int min = time/60;
        int sec = time%60;
        return [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
    
}
-(float) getDurationValue{
    return audioServices.player.duration;
}
-(NSString*)getDuration{
    int time = (int)audioServices.player.duration;
    if(time < 60){
        return [NSString stringWithFormat:@"0:%02d", time];
    }else {
        int min = time/60;
        int sec = time%60;
        return [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }

}

-(NSString*)getProgramTitle {
    return [audioServices getProgramTitle];
}
-(NSString*)getTrackTitle {
    return [audioServices getTrackTitle];
}
-(UIImage*)getCurrentImage{
    return [audioServices getCurrentImage];
}
-(NSString *)getYoutubeUrl{
    return [audioServices getYoutubeUrl];
}
-(BOOL)isPlaying{
    return [audioServices isPlaying];
}

-(BOOL)playAudioLanguageSample:(NSInteger)languageId{
    if (audioServices.samplePlayer == nil) {
        NSString * baseUrl = @"http://files.globalrecordings.net/audio/language/mp3/sample-";
        NSString * formattedUrl = [NSString stringWithFormat:@"%@%d.mp3?app=7&v=1&i=en",baseUrl, languageId];
        NSLog(@"Sample Language url: %@", formattedUrl);
        audioServices.samplePlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:formattedUrl]];
        audioServices.samplePlayer.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:audioServices.samplePlayer.currentItem];
        CMTime time = audioServices.samplePlayer.currentItem.duration;
        if (CMTimeGetSeconds(time)!=0.0f) {
            NSLog(@"CurrentItem time: %f", CMTimeGetSeconds(time));
            [audioServices.samplePlayer play];
            currentLanguageSample = languageId;
            return YES;
        } else {
            NSLog(@"No Sample");
            audioServices.samplePlayer = nil;
            return NO;
        }
    } else {
        [audioServices.samplePlayer play];
        return YES;
    }
}
-(void)stopAudioLanguageSample{
    [audioServices.samplePlayer pause];
    audioServices.samplePlayer = nil;
}
-(void)itemDidFinishPlaying {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SampleFinished" object:nil];
}
-(BOOL)sampleIsFinished{
 
    if (CMTIME_COMPARE_INLINE(audioServices.samplePlayer.currentTime, ==, audioServices.samplePlayer.currentItem.duration)) {
        return YES;
    }else{
        return NO;
    }
}
@end
