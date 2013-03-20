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


@implementation AudioHelper
@synthesize audioServices;

-(id)init{
    self = [super init];
    if(self){
        audioServices = [[AudioServices alloc] init];
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
@end
