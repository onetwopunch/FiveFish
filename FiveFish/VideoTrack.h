//
//  VideoTrack.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MediaType, Program;

@interface VideoTrack : NSManagedObject

@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) MediaType *mediaType;
@property (nonatomic, retain) Program *program;

@end
