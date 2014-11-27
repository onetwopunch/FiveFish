//
//  LanguageRepository.h
//  5fish
//
//  Created by Ryan Canty on 1/21/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This class gives access to Languages store in the database. It is used when the dev wants to update the database and when the user accesses it to find their language.
 */

#import "RepositoryBase.h"
#import "Language.h"

@interface LanguageRepository : RepositoryBase

/*
 Returns the singleton instance of the LanguageRepository
 */
+(LanguageRepository*)sharedRepo;

/*
 This method is used to initially store all languages. It will be used when the dev updates the database as well using the method described in WebServices.h. It is called from the DataAccessLayer.
 */
-(BOOL) addLanguagesWithDictionary: (NSDictionary*) jsonDict;

/*
 Returns the given language object by its id
 */
-(Language *) getLanguageById: (NSInteger) grn_id;

/*
 Returns all language objects in the database sorted by the defaultName.
 */
-(NSArray*)getAllLanguages;
@end
