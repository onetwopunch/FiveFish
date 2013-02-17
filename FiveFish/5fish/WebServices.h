//
//  WebServices.h
//  5fish
//
//  Created by Ryan Canty on 2/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject


+(NSDictionary*) getProgramStructureFromId: (NSInteger) progId;
+(NSDictionary *) getSubregions;
+(NSDictionary *) getAllLocations;
+(NSDictionary *) getAllLanguages;

+(NSOperationQueue*) sharedQueue;
+(void) downloadTracksFromProgramId:(NSInteger) grn_id WithFiles:(NSArray*) files WithBaseUrl: (NSString*) baseUrl;
@end
