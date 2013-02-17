//
//  LocationRepository.h
//  5fish
//
//  Created by Ryan Canty on 1/28/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "RepositoryBase.h"
#import "Location.h"
@interface LocationRepository : RepositoryBase

+(LocationRepository*) sharedRepo;

-(NSArray *) getAllLocations;
-(NSArray *) getContinents;
-(Location *) getLocationById: (NSInteger) grn_id;
-(BOOL) addLocationStructureFromArray: (NSArray*)continents;
-(BOOL) addLocationDataFromArray:(NSArray*) array;
//-(BOOL) addLocationWithName: (NSString*) name Id: (NSInteger) grn_id FrenchName:(NSString*) frName CountryCode: (NSString*) code Mcc: (NSString*)mcc LocType:(NSString*) locType LanguagesIds:(NSSet*) languageIds RelatedLocationIds:(NSSet*) relateLocIds;
@end
