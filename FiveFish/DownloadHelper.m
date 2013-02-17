//
//  DownloadHelper.m
//  FiveFish
//
//  Created by Ryan Canty on 2/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "DownloadHelper.h"
#import "WebServices.h"
#import "Program.h"
#import "AudioTrack.h"
#import "DataAccessLayer.h"

@implementation DownloadHelper
-(id) init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"TrackSuccess"
                                                   object:nil];
    }
    return self;
}

-(void) downloadAudioFromPrograms: (NSArray*)programs{

    for (Program *prog in programs) {
        Program * updatedProg = [DataAccessLayer getProgramById:[prog.grn_id intValue]];
        NSArray * tracks = [[NSArray alloc] initWithArray:[updatedProg.audioTracks allObjects]];
        counter += [tracks count];
    }
    for (Program * program in programs) {
        Program * updatedProg = [DataAccessLayer getProgramById:[program.grn_id intValue]];
        NSMutableArray * trackFiles = [[NSMutableArray alloc] init];
        for (AudioTrack* track in [updatedProg.audioTracks allObjects]) {
            [trackFiles addObject:[track file]];
        }
        NSString * baseUrl = updatedProg.baseAudio;
        NSInteger grn_id = [updatedProg.grn_id integerValue];
        [WebServices downloadTracksFromProgramId:grn_id WithFiles:trackFiles WithBaseUrl:baseUrl];
    }
    
}
-(void) receiveNotification: (NSNotification*) notification{
    if ([[notification object] boolValue]) {
        counter--;
        if (counter==0) {
            NSNotification * doneWithAudio = [NSNotification notificationWithName:@"AudioDone" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:doneWithAudio];
        }
    }
}



@end
