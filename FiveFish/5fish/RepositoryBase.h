//
//  RepositoryBase.h
//  Events
//
//  Created by James Hall on 8/19/10.
//  Copyright 2010 James Hall. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>


@interface RepositoryBase : NSObject {
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSMutableArray *) getResultsFromEntity:(NSString *)entityName;
- (NSMutableArray *) getResultsFromEntity:(NSString *)entityName predicateOrNil:(NSPredicate *)predicateOrNil;
- (NSMutableArray *) getResultsFromEntity:(NSString *)entityName predicateOrNil:(NSPredicate *)predicateOrNil ascSortStringOrNil:(NSArray *)ascSortStringOrNil descSortStringOrNil:(NSArray *)descSortStringOrNil;

- (NSFetchedResultsController *)fetchedResultsController:(NSString *)entityName predicateOrNil:(NSPredicate *)predicateOrNil ascSortStringOrNil:(NSArray *)ascSortStringOrNil descSortStringOrNil:(NSArray *)descSortStringOrNil batchSize:(int)batchSize;
- (void) close;
@end
