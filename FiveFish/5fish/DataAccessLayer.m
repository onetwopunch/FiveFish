//
//  DataAccessLayer.m
//  5fish
//
//  Created by Ryan Canty on 1/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "DataAccessLayer.h"
//#import "SQLHelper.h"
#import "JSONAccess.h"
#import "LanguageRepository.h"
#import "LocationRepository.h"
#import "ProgramRepository.h"
#import "WebServices.h"

@implementation DataAccessLayer









+(NSArray *) getLanguageNamesFromFile{
    
    JSONAccess *jsonAccess = [[JSONAccess alloc] init];
    NSDictionary * jsonDict = [jsonAccess getLanguageDataFromJSONFile];
    if (jsonDict==nil) {
        return [[NSArray alloc]initWithObjects:@"No", @"Data", @"Available", nil];

    }else{

        NSDictionary * languageList = [jsonDict objectForKey:@"languageList"];
        
        NSArray * pair = [languageList objectForKey:@"pair"];
        
        NSMutableArray * nameArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in pair) {
            [nameArray addObject:[dict objectForKey:@"value"]];
        }
        
        jsonAccess = nil;
        return nameArray;

    }
}
+(NSArray *) getLanguageNamesFromServer{
    JSONAccess *jsonAccess = [[JSONAccess alloc] init];
    NSDictionary * jsonDict = [jsonAccess getLanguageDataFromJSON];
    
    
    if (jsonDict==nil) {
        return [[NSArray alloc]initWithObjects:@"No", @"Data", @"Available", nil];
        NSLog(@"JSON dict is null");
    }else{
        NSDictionary * languageList = [jsonDict objectForKey:@"languageList"];
        
        
        NSArray * pair = [languageList objectForKey:@"pair"];
        
        NSMutableArray * nameArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in pair) {
            [nameArray addObject:[dict objectForKey:@"value"]];
        }
        

        return nameArray;
    }
}

+(NSArray *) getAllLanguageNames
{
    NSArray * langs = [[LanguageRepository sharedRepo] getAllLanguages];
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    for (Language * lang  in langs) {
        [tmpArray addObject:[lang defaultName]];
    }
	return tmpArray;

}


+(NSArray *) getAllLanguages{
    return [[LanguageRepository sharedRepo] getAllLanguages];
}

+(NSArray *) getAllLocations{
    return [[LocationRepository sharedRepo] getAllLocations];
}
+(NSArray *) getContinents{
    return [[LocationRepository sharedRepo] getContinents];
}
+(Program* )getProgramById: (NSInteger) grn_id{
    //We dont want to store programs in the repo more than once, so we check if the structure is downloaded
    Program * program = [[ProgramRepository sharedRepo] getProgramById:grn_id];
    if(![[ProgramRepository sharedRepo] isProgramStructureStored:program]){
        [[ProgramRepository sharedRepo] updateProgramWithId:grn_id];
        program = [[ProgramRepository sharedRepo] getProgramById: grn_id];
    }
    return program;
}


//------------------------------------------------------------------------------------------------
// initial setup DO NOT USE IN DEPLOYMENT
//------------------------------------------------------------------------------------------------


//Uses the json file to map the languages into data types the repository can use

+(BOOL) initial_setLanguages{
    
    NSDictionary* jsonDict = [WebServices getAllLanguages];
   // NSLog(@"%@", jsonDict);
    [[LanguageRepository sharedRepo] addLanguagesWithDictionary:jsonDict];
    return YES;
}

+(BOOL) initial_setLocations{

    NSDictionary *locDict = [WebServices getAllLocations];
    NSLog(@"%@", locDict);
    NSArray * locationData = [locDict objectForKey: @"locationData"];
    [[LocationRepository sharedRepo] addLocationDataFromArray:locationData];
    return YES;
}

+(BOOL) initial_setLocationStructure{
    //Unnests the necessary dictionary to pass to Location Repo
    //See Subregion link in WebServices to understand json structure
    
    NSDictionary * subDict = [WebServices getSubregions];
    NSDictionary * total = [subDict objectForKey:@"regions"];
    NSArray * planets = [total objectForKey:@"region"];
    NSDictionary * earth = [planets objectAtIndex:0];
    NSDictionary *earthSubregions = [earth objectForKey:@"subregions"];
    NSArray * continents = [earthSubregions objectForKey:@"region"];
    
    return [[LocationRepository sharedRepo] addLocationStructureFromArray:continents];
    
}
@end
