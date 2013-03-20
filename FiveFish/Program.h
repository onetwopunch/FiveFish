//
//  Program.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProgramType, AudioTrack, VideoTrack, Language;

@interface Program : NSManagedObject

@property (nonatomic, retain) NSString * baseAudio;
@property (nonatomic, retain) NSString * baseHdpi;
@property (nonatomic, retain) NSString * baseMdpi;
@property (nonatomic, retain) NSString * basePic;
@property (nonatomic, retain) NSNumber * downloaded;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * feature;
@property (nonatomic, retain) NSNumber * grn_id;
@property (nonatomic, retain) NSNumber * numTracks;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * totalSize;
@property (nonatomic, retain) NSSet *audioTracks;
@property (nonatomic, retain) NSSet *languages;
@property (nonatomic, retain) NSString * trackJsonString;
@property (nonatomic, retain) ProgramType *type;
@property (nonatomic, retain) VideoTrack *videoTrack;

@end
