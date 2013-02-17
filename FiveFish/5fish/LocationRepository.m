//
//  LocationRepository.m
//  5fish
//
//  Created by Ryan Canty on 1/28/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "LocationRepository.h"
#import "AppDelegate.h"

#import "LanguageRepository.h"
#import "Language.h"
#import "JSONAccess.h"

#define CONTINENT @"Continent"
#define REGION @"Region"
#define COUNTRY @"Country"

static LocationRepository * sharedRepo = nil;


@implementation LocationRepository

+(LocationRepository*) sharedRepo{
    if(!sharedRepo){
		sharedRepo = [[LocationRepository alloc] init];
		
		//we assign the app delegates CoreData stack to this repository,
		//that way if we need to, we can have other repositories use the same
		//stack.  Thanks @kode80!
		AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
		[sharedRepo setManagedObjectModel:appDelegate.managedObjectModel];
		[sharedRepo setPersistentStoreCoordinator:[appDelegate persistentStoreCoordinator]];
		[sharedRepo setManagedObjectContext:appDelegate.managedObjectContext];
	}
	return sharedRepo;
    
}

-(BOOL) addLocationStructureFromArray: (NSArray*)continents{
    for (NSDictionary *continent in continents) {
        //store continent name, id, etc into location
        Location * storedContinent = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
        storedContinent.grn_id = [continent objectForKey:@"id"];
        storedContinent.defaultName = [continent objectForKey:@"name"];
        storedContinent.locationType = @"Continent";
        NSMutableSet * subregions = [[NSMutableSet alloc] init];
        NSLog(@"Continent Started: %@", storedContinent.defaultName);
        
        //Dive to subregion level
        NSDictionary * contDict = [continent objectForKey:@"subregions"];
        NSArray * contRegionArray = [contDict objectForKey:@"region"];
        for (NSDictionary * contRegion in contRegionArray) {
            
            //store region data such as Eastern Africa
            Location * storedRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
            storedRegion.grn_id = [contRegion objectForKey:@"id"];
            storedRegion.defaultName = [contRegion objectForKey:@"name"];
            storedRegion.locationType = @"Region";
            NSMutableSet * countries = [[NSMutableSet alloc]init];
            NSLog(@"==Region Started: %@", storedRegion.defaultName);
            
            
            //Dive to country level
            NSDictionary * countryDict = [contRegion objectForKey:@"subregions"];

            NSArray * countryArray = [countryDict objectForKey:@"region"];
            
            for (NSDictionary* country in countryArray) {
                
                //store country data
                Location * storedCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
                storedCountry.grn_id = [country objectForKey:@"id"];
                storedCountry.defaultName = [country objectForKey:@"name"];
                storedCountry.countryCode = [country objectForKey:@"code"];
                storedCountry.locationType = @"Country";
                [countries addObject:storedCountry];
                NSLog(@"====Country added: %@", storedCountry.defaultName);
            }
            storedRegion.relatedLocations = countries;
            [subregions addObject:storedRegion];
            NSLog(@"==Region added: %@", storedRegion.defaultName );
        }
        storedContinent.relatedLocations = subregions;
        NSLog(@"====Continent added: %@", storedContinent.defaultName);
    }
    NSError * error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Location structure was unable to save %@ %@", error, [error userInfo]);
        return NO;
    }
    return YES;
    
}

-(BOOL) addLocationDataFromArray:(NSArray*) array{
    for (NSDictionary * loc in array) {
        
        //Get data from dictionary
        NSInteger grn_id = [[loc objectForKey:@"id"] intValue];
        NSDictionary *names = [loc objectForKey:@"Names"];
        NSString * frenchName = [names objectForKey:@"frn"];
        NSArray * languageIds = [loc objectForKey:@"Languages"];
        NSArray * rel = [loc objectForKey:@"Related-Locations"];
        
        //Create new location object in context
        Location *location = [self getLocationById:grn_id];
        
        //set basic attributes
        [location setFrenchName:frenchName];
        
        //set Language objects
        NSMutableSet * langSet = [[NSMutableSet alloc]initWithCapacity:[languageIds count]];
        for (NSNumber * grn_id in languageIds) {
            NSInteger gid = [grn_id integerValue];
            
            Language * lang = [[LanguageRepository sharedRepo] getLanguageById:gid];
            if (lang != nil) {
                [langSet addObject:lang];
            }
            
        }
        [location setLanguages:langSet];
        
        NSMutableSet * related = [[NSMutableSet alloc] initWithSet:location.relatedLocations];
        for (NSNumber* relId in rel) {
            Location * relLoc = [self getLocationById:[relId intValue]];
            if (relLoc !=nil) {
                [related addObject:relLoc];    
            }
        
        }
        [location setRelatedLocations:related];
        
        NSLog(@"Location updated: %@", location.defaultName);
    }
    // Save the context.
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved error saving Language %@, %@", error, [error userInfo]);
        return NO;
    }
    
    
    return YES;
        

}


-(BOOL) addLocationWithName: (NSString*) name Id: (NSInteger) grn_id FrenchName:(NSString*) frName CountryCode: (NSString*) code Mcc: (NSString*)mcc LocType:(NSString*) locType LanguagesIds:(NSSet*) languageIds RelatedLocationIds:(NSSet*) relateLocIds{
    
    //Create new location object in context
    NSManagedObjectContext *context = [self managedObjectContext];
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
    
    //set basic attributes
    [location setDefaultName:name];
    [location setFrenchName:frName];
    [location setGrn_id:[NSNumber numberWithInt:grn_id]];
    [location setCountryCode:code];
    [location setMcc:mcc];
    [location setLocationType:locType];
    
    //set Language objects
    NSMutableSet * langSet = [[NSMutableSet alloc]initWithCapacity:[languageIds count]];
    for (NSNumber * grn_id in languageIds) {
        NSInteger gid = [grn_id integerValue];
    
        Language * lang = [[LanguageRepository sharedRepo] getLanguageById:gid];
        if (lang != nil) {
            [langSet addObject:lang];
        }
    
    }
    [location setLanguages:langSet];
    
    //if we set the related locations before all locations are in the DB, we will get lots of 'not found' errors
    // so we do this after db is loaded
    
    
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error saving Language %@, %@", error, [error userInfo]);
        return NO;
    }
    
    NSLog(@"Language added: %@", name);
    return YES;
}

-(NSArray* )getAllLocations{
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity: locationEntity];
	
	NSError *error = nil;
	NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (!results || error) {
		NSLog(@"[ERROR] COREDATA: Fetch request raised an error - '%@'", [error description]);
		return nil;
	}
	
    return [[NSArray alloc]initWithArray: results];
    
}

-(NSArray *) getContinents{
    NSEntityDescription * location = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"defaultName" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:nameSort]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"locationType == %@", CONTINENT];
    [request setPredicate:pred];
    [request setEntity:location];
    NSError * error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;
}



-(Location *) getLocationById: (NSInteger) grn_id{
    NSEntityDescription * location = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"grn_id == %d", grn_id];
    [request setPredicate:pred];
    [request setEntity:location];
    NSError * error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if([results count] >1){
        NSLog(@"More than one location returned for the specified id");
        return nil;
    }
    //returns the one and only language with that id
    return ([results count]==0)? nil: [results objectAtIndex:0];
    
}
@end
