//
//  WebServices.h
//  5fish
//
//  Created by Ryan Canty on 2/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject{
    float queueSize;
}
@property (strong, nonatomic) NSOperationQueue * queue;

+(NSDictionary*) getProgramStructureFromId: (NSInteger) progId;
+(NSDictionary*) getProgramStructureFromIdCompat: (NSInteger) progId;
+(NSDictionary *) getSubregions;
+(NSDictionary *) getAllLocations;
+(NSDictionary *) getAllLanguages;

//+(NSOperationQueue*) sharedQueue;

-(void) downloadTracksFromProgramArray:(NSArray*) programs;
@end
