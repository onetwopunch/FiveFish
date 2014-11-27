//
//  AudioHelper.h
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This class gives the UI access to the AudioServices.
 */
#import <Foundation/Foundation.h>
#import "AudioServices.h"

@interface AudioHelper : NSObject{
    NSInteger currentLanguageSample;
}
@property (strong, nonatomic) AudioServices *audioServices;

-(void)queueTracksForProgramId:(NSInteger)gid;
-(void)prepareToPlay;
-(void)play;
-(void)pause;
-(void)stop;
-(void)next;
-(void)previous;
-(void)volume:(float)vol;
-(NSString*)getCurrentTime;
-(NSString*)getDuration;
-(NSString*)getProgramTitle;
-(NSString*)getTrackTitle;
-(NSString *)getYoutubeUrl;
-(UIImage*)getCurrentImage;
-(void)setCurrentTime:(float)val;
-(float) getCurrentTimeValue;
-(float) getDurationValue;
-(BOOL)isPlaying;
-(BOOL)playAudioLanguageSample:(NSInteger)languageId;
-(void)stopAudioLanguageSample;
-(BOOL)sampleIsFinished;

@end
