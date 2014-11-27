//
//  WebServices.h
//  5fish
//
//  Created by Ryan Canty on 2/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject{
    float queueSize;
}
@property (strong, nonatomic) NSOperationQueue * queue;

/*
 Gets the structure of the requested program including the track names, size, etc. from the server via JSON feeds.
 */
+(NSDictionary*) getProgramStructureFromId: (NSInteger) progId;
/*
 Gets the structure of the requested program including the track names, size, etc. from the server via JSON feeds for the older versions of JSON feeds
 */
+(NSDictionary*) getProgramStructureFromIdCompat: (NSInteger) progId;

/* 
 Used only to populate the database with languages, locations, etc. This should only be used in updates, keeping in mind that if the structure of the JSON feeds are altered, these methods must be altered to match. When the user first opens the app, a sqlite DB is loaded from the main bundle into the Docs directory and not loaded directly from the server. This keeps install time minimal. 
 
 If the DB or JSON structure is altered in any way:
 (1) you will need to delete the old FiveFish1.sqlite from the main bundle and 
 (2) replace it with the new DB 
 (3) built by uncommenting the right bar button instantiation in MainMenuViewController.m,
 (4) setting the DEBUG macro to 1, and
 (5) tapping that button during runtime.
 (6) Just find the created *.sqlite file in the Simulator/Device's Documents directory and copy it into the main bundle.
 */
+(NSDictionary *) getSubregions;
+(NSDictionary *) getAllLocations;
+(NSDictionary *) getAllLanguages;

/*
 These are helper methods to create the necessary directories in the Documents directory
 */
+(NSString*)createAudioDir;
+(NSString*)createPictureDir;
+(NSString*)createProgramDir:(NSString*)basePath WithId: (NSInteger) grn_id;

/*
 To handle downloads, we need to have a seperate thread for downloading than the UI threadso that the progress bar can be updated. However, this also means we need to have notifications beign sent from our download thread to our UI thread.
 */
-(void) downloadTracksFromProgramArray:(NSArray*) programs;
@end
