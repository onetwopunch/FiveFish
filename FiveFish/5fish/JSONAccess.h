//
//  JSONAccess.h
//  5fish
//
//  Created by Ryan Canty on 1/20/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONAccess : NSObject
@property (strong,nonatomic) NSDictionary * jsonDictionary;

-(void) setDictionaryFromJSON: (NSString * ) url;
-(void) setDictionaryFromJSONAsync: (NSString * ) url;
-(NSDictionary*) getLanguageDataFromJSON;
-(NSDictionary*) getProgramDataFromJSON: (NSInteger) progId;



-(NSDictionary*) getLanguageDataFromJSONFile;
-(NSDictionary *) getProgramDataFromJSONFile;
-(NSDictionary*) getLocationDataFromJSONFile;

-(void)setJSONFromFile: (NSString *)fileLocation;
@end
