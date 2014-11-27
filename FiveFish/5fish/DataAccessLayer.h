//
//  DataAccessLayer.h
//  5fish
//
//  Created by Ryan Canty on 1/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This class give the dev access to all of the repositories and indirectly, to all the CoreData. You should never use the methods in the repository directly as this violates the Seperation of concerns principle. Instead, use this class to access them. 
 */
#import <Foundation/Foundation.h>
#import "Program.h"
#import "ProgramType.h"
#import "Language.h"
#import "Location.h"

@interface DataAccessLayer : NSObject
/*
 Returns an array with Location objects that describe continents. This is used in the ContinentsViewController.
 */
+(NSArray *) getContinents;

/*
 Updates and returns the program by its id. Used in WebServices to download programs.
 */
+(Program* )getProgramById: (NSInteger) grn_id;

/*
 Updates and returns the program by its id and a dictionary from json. This is used to store a programs structure after its received by bluetooth.
 */
+(Program* )getProgramById:(NSInteger)grn_id JsonDictionary:(NSDictionary*) jsonDict;

/*
 Deletes the specified programs files and removes it from "My Programs"
 */
+(BOOL) deleteProgramData: (Program*) program;

/*
 Sets the downladed flag for the specified program to be YES
 */
+(void) setProgramDownloaded:(Program*)program;

/*
 Returns an image from the main bundle by its country code. Each flag is named <code>.png
 */
+(UIImage*)getFlagImageByCode: (NSString*) code;

/*
 Returns the image for the location. Used to get the colored fish for the continents.
 */
+(UIImage*) getImageById: (NSNumber*)grn_id;

/*
 Returns an array of the programs that have been downloaded and sort them by languages. This is the data for the MyProgramsViewController
 */
+(NSDictionary*)getDownloadedProgramsByLanguage;

/*
 Returns the programs that have been downloaded.
 */
+(NSArray*) getDownloadedPrograms;

/*
 Returns a list of the tracks for a given program sorted by their file names.
 */
+(NSArray*) getSortedTracks: (Program*) program;

/*
 These methods were used for testing and not in deployment
 */
+(NSArray *) getAllLanguageNames;
+(NSArray *) getAllLanguages;
+(NSArray *) getAllLocations;

/*
//------------------------------------
//Initial setup
These methods are only used in the initial setup of the database and in updates. See WebServices.h for more info as to how to update the application
 
*/
+(BOOL) initial_setLocationStructure;
+(BOOL) initial_setLanguages;
+(BOOL) initial_setLocations;

@end
