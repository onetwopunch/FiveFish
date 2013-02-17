//
//  JSONAccess.m
//  5fish
//
//  Created by Ryan Canty on 1/20/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "JSONAccess.h"

@implementation JSONAccess
@synthesize jsonDictionary;


-(NSDictionary*) getLocationDataFromJSONFile{
    
    [self setJSONFromFile:@"location-ALL-v1.json"];
    return self.jsonDictionary;
    
}
-(NSDictionary *) getProgramDataFromJSONFile{
    [self setJSONFromFile:@"program-23050.json"];
    return self.jsonDictionary;
}
-(NSDictionary *) getLanguageDataFromJSONFile{
    [self setJSONFromFile:@"language-ALL.json"];
    return  self.jsonDictionary;
}




-(void)setJSONFromFile: (NSString *)fileLocation{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //NSLog(@"Result: %@", result);
    if (error != nil){
        self.jsonDictionary = nil;
        NSLog(@"Error: %@", error);
    }
    else{
        self.jsonDictionary = [NSDictionary dictionaryWithDictionary:result];
    }
    
}

@end
