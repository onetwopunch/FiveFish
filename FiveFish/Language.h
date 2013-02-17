//
//  Language.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AltName, Language, Location, Program, Sample;

@interface Language : NSManagedObject

@property (nonatomic, retain) NSString * defaultName;
@property (nonatomic, retain) NSNumber * grn_id;
@property (nonatomic, retain) NSString * iso;
@property (nonatomic, retain) NSSet *altNames;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *majorLanguages;
@property (nonatomic, retain) NSSet *program;
@property (nonatomic, retain) Sample *sample;
@end

@interface Language (CoreDataGeneratedAccessors)

- (void)addAltNamesObject:(AltName *)value;
- (void)removeAltNamesObject:(AltName *)value;
- (void)addAltNames:(NSSet *)values;
- (void)removeAltNames:(NSSet *)values;

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addMajorLanguagesObject:(Language *)value;
- (void)removeMajorLanguagesObject:(Language *)value;
- (void)addMajorLanguages:(NSSet *)values;
- (void)removeMajorLanguages:(NSSet *)values;

- (void)addProgramObject:(Program *)value;
- (void)removeProgramObject:(Program *)value;
- (void)addProgram:(NSSet *)values;
- (void)removeProgram:(NSSet *)values;

@end
