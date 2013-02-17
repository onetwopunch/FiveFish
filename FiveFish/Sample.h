//
//  Sample.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Language;

@interface Sample : NSManagedObject

@property (nonatomic, retain) NSNumber * grn_id;
@property (nonatomic, retain) NSString * youtube;
@property (nonatomic, retain) Language *language;

@end
