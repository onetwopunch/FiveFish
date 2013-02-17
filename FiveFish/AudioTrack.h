//
//  AudioTrack.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Program;

@interface AudioTrack : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSNumber * grn_id;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Program *program;

@end
