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
        
    }
    return self;
}

-(void) downloadAudioFromPrograms: (NSArray*)programs{

    
    WebServices *web = [[WebServices alloc] init];
    [web downloadTracksFromProgramArray:programs];
    for (Program* prog in programs) {
        [DataAccessLayer setProgramDownloaded:prog];
    }
}





@end
