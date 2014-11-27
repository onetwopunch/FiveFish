//
//  LocationRepository.h
//  5fish
//
//  Created by Ryan Canty on 1/28/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This class is used to store the locations from JSON feeds on update. See WebServices.h for more info. ALso used to retrieve locations for the user to navigate to their continent and country.
 */
#import "RepositoryBase.h"
#import "Location.h"
@interface LocationRepository : RepositoryBase

/*
 Returns the singleton instance of the LocationRepository
 */
+(LocationRepository*) sharedRepo;

/*
 Returns all locations. This method is not used currently, it was implemented for testing purposes.
 */
-(NSArray *) getAllLocations;

/*
 Returns and array of each continent. This is the starting point for the location browsing user interface.
 */
-(NSArray *) getContinents;

/*
 Returns a location given by its id.
 */
-(Location *) getLocationById: (NSInteger) grn_id;

/*
 These methods are used to store locations into the database. Again, see WebServices.h for more info as to how the initial data translation from JSON to CoreData works.
 */
-(BOOL) addLocationStructureFromArray: (NSArray*)continents;
-(BOOL) addLocationDataFromArray:(NSArray*) array;

@end
