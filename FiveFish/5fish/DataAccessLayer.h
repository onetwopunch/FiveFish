//
//  DataAccessLayer.h
//  5fish
//
//  Created by Ryan Canty on 1/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"
#import "ProgramType.h"
#import "Language.h"
#import "Location.h"

@interface DataAccessLayer : NSObject

+(NSArray *) getLanguageNamesFromServer;
+(NSArray *) getLanguageNamesFromFile;
+(NSArray *) getAllLanguageNames;
+(NSArray *) getAllLanguages;
+(NSArray *) getAllLocations;
+(NSArray *) getContinents;
+(Program* )getProgramById: (NSInteger) grn_id;

//------------------------------------
//Initial setup
+(BOOL) initial_setLocationStructure;
+(BOOL) initial_setLanguages;
+(BOOL) initial_setLocations;

@end
