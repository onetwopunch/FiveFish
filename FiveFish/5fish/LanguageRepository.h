//
//  LanguageRepository.h
//  5fish
//
//  Created by Ryan Canty on 1/21/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "RepositoryBase.h"
#import "Language.h"

@interface LanguageRepository : RepositoryBase



+(LanguageRepository*)sharedRepo;
-(Language*) getNewTempLanguage;
-(BOOL) addLanguagesWithDictionary: (NSDictionary*) jsonDict;
-(Language *) getLanguageById: (NSInteger) grn_id;
-(NSArray*)getAllLanguages;
@end
