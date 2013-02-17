//
//  MediaType.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VideoTrack;

@interface MediaType : NSManagedObject

@property (nonatomic, retain) NSString * baseUrl;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) VideoTrack *videoTrack;

@end
