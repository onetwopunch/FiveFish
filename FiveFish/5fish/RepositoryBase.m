//
//  RepositoryBase.m
//  Events
//
//  Created by James Hall on 8/19/10.
//  Copyright 2010 James Hall. All rights reserved.
//

#import "RepositoryBase.h"

@implementation RepositoryBase

@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator;

-(void) close
{
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			abort();
        } 

    }
	
}
- (NSMutableArray *) getResultsFromEntity:(NSString *)entityName
{
	return [self getResultsFromEntity:entityName predicateOrNil:nil];
}
- (NSMutableArray *) getResultsFromEntity:(NSString *)entityName predicateOrNil:(NSPredicate *)predicateOrNil;
{
	return [self getResultsFromEntity:entityName predicateOrNil:predicateOrNil ascSortStringOrNil:nil descSortStringOrNil:nil];
}

- (NSMutableArray *) getResultsFromEntity:(NSString *)entityName predicateOrNil:(NSPredicate *)predicateOrNil ascSortStringOrNil:(NSArray *)ascSortStringOrNil descSortStringOrNil:(NSArray *)descSortStringOrNil
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:[self managedObjectContext]]; 
	[request setEntity:entity]; 
	
	if(predicateOrNil != nil)
	{
		[request setPredicate:predicateOrNil];
	}
	
	// Edit the sort key as appropriate.
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc]init];
	
	if(ascSortStringOrNil != nil)
	{
		for (NSString *asc in ascSortStringOrNil)
		{
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:asc ascending:NO];
			[sortDescriptors addObject:sortDescriptor];
		}
    }
	if(descSortStringOrNil != nil)
	{
		for (NSString *desc in descSortStringOrNil)
		{
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:desc ascending:NO];
			[sortDescriptors addObject:sortDescriptor];
		}
    }
    [request setSortDescriptors:sortDescriptors];
	
	NSError *error; 
	
	NSMutableArray *mutableFetchResults = [[[self managedObjectContext] 
											executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		// Handle the error. 
	} 
	
	
	return mutableFetchResults;
}

- (NSFetchedResultsController *)fetchedResultsController:(NSString *)entityName predicateOrNil:(NSPredicate *)predicateOrNil ascSortStringOrNil:(NSArray *)ascSortStringOrNil descSortStringOrNil:(NSArray *)descSortStringOrNil batchSize:(int)batchSize  {
    
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:batchSize];
    
    // Edit the sort key as appropriate.
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc]init];
	
	if(ascSortStringOrNil != nil)
	{
		for (NSString *asc in ascSortStringOrNil)
		{
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:asc ascending:NO];
			[sortDescriptors addObject:sortDescriptor];
		}
    }
	if(descSortStringOrNil != nil)
	{
		for (NSString *desc in descSortStringOrNil)
		{
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:desc ascending:NO];
			[sortDescriptors addObject:sortDescriptor];
		}
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return aFetchedResultsController;
}    
@end
