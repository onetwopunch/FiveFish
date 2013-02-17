//
//  Location.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * defaultName;
@property (nonatomic, retain) NSString * frenchName;
@property (nonatomic, retain) NSNumber * grn_id;
@property (nonatomic, retain) NSString * locationType;
@property (nonatomic, retain) NSString * mcc;
@property (nonatomic, retain) NSSet *languages;
@property (nonatomic, retain) NSSet *relatedLocations;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addLanguagesObject:(NSManagedObject *)value;
- (void)removeLanguagesObject:(NSManagedObject *)value;
- (void)addLanguages:(NSSet *)values;
- (void)removeLanguages:(NSSet *)values;

- (void)addRelatedLocationsObject:(Location *)value;
- (void)removeRelatedLocationsObject:(Location *)value;
- (void)addRelatedLocations:(NSSet *)values;
- (void)removeRelatedLocations:(NSSet *)values;

@end
