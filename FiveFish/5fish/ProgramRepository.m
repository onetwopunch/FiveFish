//
//  ProgramRepository.m
//  5fish
//
//  Created by Ryan Canty on 1/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "ProgramRepository.h"
#import "AppDelegate.h"
#import "JSONAccess.h"
#import "MediaType.h"
#import "WebServices.h"

static ProgramRepository * sharedRepo = nil;

@implementation ProgramRepository

+(ProgramRepository*)sharedRepo{
    if(!sharedRepo){
		sharedRepo = [[ProgramRepository alloc] init];
		
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

-(BOOL) updateProgramWithId: (NSInteger) gid JsonDictionary:(NSDictionary*) jsonDict{
    
    BOOL isYoutubeNull = NO;
    BOOL oldVersion = NO;
    NSDictionary * progFromJson;
    if (jsonDict ==nil) {
        //get json from web
        progFromJson = [WebServices getProgramStructureFromId:gid];
        if ([[progFromJson allKeys] containsObject:@"error"]) {
            progFromJson = [WebServices getProgramStructureFromIdCompat:gid];
            oldVersion = YES;
        }
    } else {
        //get json from bluetooth
        progFromJson = jsonDict;
    }
    //Create jsonString for tracks. This is to transfer tracks via bluetooth
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:progFromJson options:nil error:&error];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    //get values from dictionary
    NSLog(@"Program from Web %@", progFromJson);
    NSString * baseAudio = [progFromJson objectForKey:@"baseAudio"];
    NSString * baseHdpi = [progFromJson objectForKey:@"baseHdpi"];
    NSString * baseMdpi = [progFromJson objectForKey:@"baseMdpi"];
    NSString * basePic = [progFromJson objectForKey: @"basePic"];
    NSInteger grn_id = [[progFromJson objectForKey:@"grnId"] intValue];
    NSArray *audioTracks;
    if(oldVersion){
        audioTracks = [progFromJson objectForKey:@"tracks"];
    }else{
        NSDictionary * aDict = [progFromJson objectForKey:@"tracks"];
        audioTracks = [aDict objectForKey:@"track"];
    }
    NSString * youtube = [progFromJson objectForKey:@"youTube"];
    if (![youtube respondsToSelector:@selector(isEqualToString:)]) {
        isYoutubeNull= YES;
    }
    
    Program *program = [self getProgramById:grn_id];
    
    [program setTrackJsonString:jsonString];
    
    [program setBaseAudio:baseAudio];
    [program setBaseHdpi:baseHdpi];
    [program setBaseMdpi:baseMdpi];
    [program setBasePic:basePic];
    
    if (!isYoutubeNull) {
        VideoTrack *vTrack = [NSEntityDescription insertNewObjectForEntityForName:@"VideoTrack" inManagedObjectContext:managedObjectContext];
        MediaType * mType = [NSEntityDescription insertNewObjectForEntityForName:@"MediaType" inManagedObjectContext:managedObjectContext];
        
        [mType setBaseUrl: @"http://www.youtube.com/watch?="];
        [mType setType:@"YouTube"];
        [vTrack setReference:youtube];
        [vTrack setMediaType:mType];
        [program setVideoTrack:vTrack];
    }
    
    
    
    NSMutableSet *aTrackSet = [[NSMutableSet alloc] init];
    long totalFileSize = 0;
    int totalDuration = 0;
    int numTracks = [audioTracks count];
    for (NSDictionary * track  in audioTracks) {
        AudioTrack * aTrack = [NSEntityDescription insertNewObjectForEntityForName:@"AudioTrack" inManagedObjectContext:managedObjectContext];
        aTrack.title        = [track objectForKey:@"title"];
        aTrack.grn_id       = [NSNumber numberWithInt:[[track objectForKey:@"id"] intValue] ];
        aTrack.duration     = [NSNumber numberWithInt:[[track objectForKey:@"duration"] intValue] ];
        aTrack.fileSize     = [NSNumber numberWithLong: [[track objectForKey:@"fileSize"] intValue]];
        aTrack.file         = [track objectForKey:@"file"];
        aTrack.picture      = [track objectForKey:@"picture"];
        [aTrackSet addObject:aTrack];
        totalDuration += [aTrack.duration intValue];
        totalFileSize += [aTrack.fileSize longValue];
    }
    
    program.totalSize = [NSNumber numberWithLong: totalFileSize];
    program.duration = [NSNumber numberWithInt:totalDuration];
    program.numTracks = [NSNumber numberWithInt:numTracks];
    program.downloaded = [NSNumber numberWithBool:YES];
    [program setAudioTracks:aTrackSet];
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Program Update Failed: %@", error);
        return NO;
    }
    return YES;
    
}



-(Program*) getProgramById:(NSInteger) grn_id{
    NSEntityDescription * program = [NSEntityDescription entityForName:@"Program" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"grn_id == %d", grn_id];
    [request setPredicate:pred];
    [request setEntity:program];
    NSError * error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if([results count] >1){
        NSLog(@"More than one program returned for the specified id");
        //return nil;
    }
    //returns the one and only language with that id
    return [results objectAtIndex:0];//([results count]==0)? nil: [results objectAtIndex:0];
}

-(NSArray*) getAllPrograms{
    NSEntityDescription *programEntity = [NSEntityDescription entityForName:@"Program" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSSortDescriptor * des = [[NSSortDescriptor alloc] initWithKey:@"grn_id" ascending:NO];
    [request setEntity: programEntity];
	[request setSortDescriptors:[[NSArray alloc]initWithObjects:des, nil]];
	NSError *error = nil;
	NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (!results || error) {
		NSLog(@"[ERROR] COREDATA: Fetch request raised an error - '%@'", [error description]);
		return nil;
	}
	
    return [[NSArray alloc]initWithArray: results];
    
}

-(NSArray* )getDownloadedPrograms{
    NSEntityDescription * program = [NSEntityDescription entityForName:@"Program"
                                                inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"downloaded == %@", [NSNumber numberWithBool:YES]];
    [request setPredicate:pred];
    [request setEntity:program];
    NSError * error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


//Structure is stored when the program is seen by the user. This allows the user to look at the structure of the program
//again without being on the internet
-(BOOL) isProgramStructureStored:(Program*)program{
    if ([program.audioTracks count]==0) {
        return NO;
    }
    return YES;
    
}
@end
