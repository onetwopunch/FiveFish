//
//  DataAccessLayer.m
//  5fish
//
//  Created by Ryan Canty on 1/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "DataAccessLayer.h"
#import "LanguageRepository.h"
#import "LocationRepository.h"
#import "ProgramRepository.h"
#import "WebServices.h"

@implementation DataAccessLayer

+(UIImage*) getImageById: (NSNumber*)grn_id{
    
    NSString * path = [NSString stringWithFormat:@"%d.png", [grn_id intValue]];
    return [UIImage imageNamed:path];
}
+(UIImage*)getFlagImageByCode: (NSString*) code{
    NSString * path;
    if (code!=nil)
        
        path = [NSString stringWithFormat:@"%@.png", [code lowercaseString]];
    else
        path = @"placeholder.png";
    
    return [UIImage imageNamed:path];
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
        [[ProgramRepository sharedRepo] updateProgramWithId:grn_id JsonDictionary:nil];
        program = [[ProgramRepository sharedRepo] getProgramById: grn_id];
    }
    return program;
}

//allows us to pass a json string to the repo to handle bluetooth receive
+(Program* )getProgramById:(NSInteger)grn_id JsonDictionary:(NSDictionary*) jsonDict{
    Program * program = [[ProgramRepository sharedRepo] getProgramById:grn_id];
    if(![[ProgramRepository sharedRepo] isProgramStructureStored:program]){
        [[ProgramRepository sharedRepo] updateProgramWithId:grn_id JsonDictionary:jsonDict];
        program = [[ProgramRepository sharedRepo] getProgramById: grn_id];
    }
    return program;
}
+(NSArray*) getDownloadedPrograms{
    return [[ProgramRepository sharedRepo] getDownloadedPrograms];
}
+(NSDictionary*)getDownloadedProgramsByLanguage{
    NSArray * programs = [[ProgramRepository sharedRepo]getDownloadedPrograms];
    NSMutableDictionary * progByLang = [[NSMutableDictionary alloc] init];
    for(Program * prog in programs){
        NSString * languageName;
        NSMutableArray * progArray;
        @try{
            //get language
            NSArray * languages = [prog.languages allObjects];
            Language* language = [languages objectAtIndex:0];
            languageName = language.defaultName;
            
            //see if we've already stored an array of programs in it
            if ([progByLang objectForKey:languageName] ==nil) {
                progArray = [[NSMutableArray alloc] initWithObjects:prog, nil];
            }
            
            //if it already exists, just add the program to it
            else{
                progArray = [progByLang objectForKey:languageName];
                [progArray addObject:prog];
            }
            if ([languages count] >1) {
                NSLog(@"More than one language for program, %@", prog.title); 
            }
        }
        @catch (NSException *e) {
            languageName = @"Unknown Language";
        }
        [progByLang setObject:progArray forKey:languageName];
    }
    return progByLang;
}

+(NSArray*) getSortedTracks: (Program*) program{
    
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"file" ascending:YES];
    return [program.audioTracks sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
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
