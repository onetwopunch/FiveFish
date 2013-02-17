//
//  AltName.h
//  FiveFish
//
//  Created by Ryan Canty on 2/11/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Language;

@interface AltName : NSManagedObject

@property (nonatomic, retain) NSString * altName;
@property (nonatomic, retain) Language *language;

@end
