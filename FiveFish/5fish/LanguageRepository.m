//
//  LanguageRepository.m
//  5fish
//
//  Created by Ryan Canty on 1/21/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "LanguageRepository.h"
#import "Language.h"
#import "Sample.h"
#import "AppDelegate.h"
#import "Program.h"
#import "ProgramType.h"
#import "AltName.h"

static LanguageRepository *sharedRepo = nil;

@implementation LanguageRepository

+(LanguageRepository*)sharedRepo{
	if(!sharedRepo){
		sharedRepo = [[LanguageRepository alloc] init];
		
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


-(BOOL) addLanguagesWithDictionary: (NSDictionary*) jsonDict{
    
   // NSLog(@"jsonDict: %@", jsonDict);
    NSDictionary * languages = [jsonDict objectForKey:@"languages"];
    NSArray * language = [languages objectForKey:@"language"];
    
    NSDictionary * progTypeDict = [jsonDict objectForKey:@"programTypes"];
    NSArray * programTypes= [progTypeDict objectForKey:@"programType"];
    
    for (NSDictionary * d in language) {
        
      //  NSLog(@"d: %@", d);
        
        NSNumber * grn_id = [d objectForKey:@"id"];
        NSString * defaultName = [d objectForKey:@"name"];
        NSString * iso = [d objectForKey:@"iso"];
        NSDictionary * sample = [d objectForKey:@"sample"];
        
        NSMutableArray * programs = [[NSMutableArray alloc] init];
        
        NSMutableArray * altNames = [[NSMutableArray alloc] init];
        NSDictionary * progDict = [d objectForKey:@"programs"];
        NSArray * progArray = [progDict objectForKey:@"program"];
    
        //assign program types 
        for (NSDictionary * prog in progArray) {
            NSMutableDictionary * progMutDict = [[NSMutableDictionary alloc]initWithDictionary:prog];
            for (NSDictionary *progType in programTypes) {
                if([[progMutDict objectForKey:@"programType"] intValue]
                            == [[progType objectForKey:@"typeId"] intValue]){
                    
                    [progMutDict setObject:progType forKey:@"programType"];
                    break;
                }
            }
            
            [programs addObject:progMutDict];
        }
        
       // NSLog(@"programs: %@", programs);
        NSDictionary * alternateNames = [d objectForKey:@"alternateNames"];
        for (NSString * altName in [alternateNames objectForKey:@"name"]) {
            [altNames addObject:altName];
        }
    
    
        // Create a new instance of the entity managed by the fetched results controller.
        Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:managedObjectContext];
        
        //Set Language's Id, Name, and ISO
        language.grn_id = grn_id;
        language.defaultName = defaultName;
        
        if (iso ==nil||[iso isKindOfClass:[NSNull class]]) {
            language.iso = @"";
        }else{
            language.iso = iso;
        }
        
        //Build and set Language's Programs
        NSMutableSet * programSet = [[NSMutableSet alloc] init];
        for (NSDictionary * progDict  in programs) {
                        
            Program * program = [NSEntityDescription insertNewObjectForEntityForName:@"Program" inManagedObjectContext:managedObjectContext];
            [program  setDuration:[NSNumber numberWithInt:[[progDict objectForKey:@"duration"] intValue]]];
            [program setGrn_id:[NSNumber numberWithInt:[[progDict objectForKey:@"id"] intValue]]];
            [program setTitle:[progDict objectForKey:@"title"]];
            [program setNumTracks:[NSNumber numberWithInt:[[progDict objectForKey:@"tracks"] intValue]]];
            [program setDownloaded:[NSNumber numberWithBool:NO]];
            
            ProgramType * type = [NSEntityDescription insertNewObjectForEntityForName:@"ProgramType" inManagedObjectContext:managedObjectContext];
                NSDictionary * typeDict = [progDict objectForKey:@"programType"];
                type.desc = [typeDict objectForKey:@"description"];
            
            
                NSInteger typeGid = [[typeDict objectForKey:@"typeId"] intValue];
                NSNumber *num = [NSNumber numberWithInteger:typeGid];   
                //[type setGrn_id:num];
            [type setValue:num forKey:@"grn_id"];
            
            type.pictureUrl = [typeDict objectForKey:@"picture"];
            program.type = type;
            
            [programSet addObject:program];
        }
        [language setProgram:programSet];
        
        
        //Build and set AltNames
        NSMutableSet *altNameSet = [[NSMutableSet alloc] init];
        for (NSString * name in altNames) {
            AltName *alt = [NSEntityDescription insertNewObjectForEntityForName:@"AltName" inManagedObjectContext:managedObjectContext];
            [alt setAltName:name];
            [altNameSet addObject:alt];
        }
        [language setAltNames:altNameSet];
        
        
        //Build and set Language's Sample
        Sample * samp = [NSEntityDescription insertNewObjectForEntityForName:@"Sample"
                                                      inManagedObjectContext:managedObjectContext];
        //NSLog(@"Sample Dictionary: %@", sample);
        
        [samp setGrn_id:[sample objectForKey:@"id"]];
        [samp setYoutube:[sample objectForKey:@"youTube"]];
        [language setSample:samp];
        NSLog(@"Language added: %@", defaultName);
    }
    
    // Save the context.
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved error saving Language %@, %@", error, [error userInfo]);
        return NO;
    }
    
  
    return YES;

}
-(Language *) getLanguageById: (NSInteger) grn_id{
    NSEntityDescription * language = [NSEntityDescription entityForName:@"Language" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"grn_id == %d", grn_id];
    [request setPredicate:pred];
    [request setEntity:language];
    NSError * error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if([results count] >1){
        NSLog(@"More than one language returned for the specified id");
        return nil;
    }
    //returns the one and only language with that id
    return ([results count]==0)? nil: [results objectAtIndex:0];

}
-(NSArray*)getAllLanguages{
    NSEntityDescription *languageEntity = [NSEntityDescription entityForName:@"Language" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSSortDescriptor * des = [[NSSortDescriptor alloc] initWithKey:@"defaultName" ascending:YES];
    [request setEntity: languageEntity];
	[request setSortDescriptors:[[NSArray alloc] initWithObjects:des, nil]];
	NSError *error = nil;
	NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (!results || error) {
		NSLog(@"[ERROR] COREDATA: Fetch request raised an error - '%@'", [error description]);
		return nil;
	}
	
    return [[NSArray alloc]initWithArray: results];
    
}
@end
