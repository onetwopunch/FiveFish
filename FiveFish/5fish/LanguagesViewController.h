//
//  LanguagesViewController.h
//  5fish
//
//  Created by Ryan Canty on 1/15/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Accesses the LanguageRepository via the DataAccessLayer to show the user the languages for a paricular country.
 */
#import <UIKit/UIKit.h>
#import "AudioHelper.h"

@interface LanguagesViewController : UITableViewController
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray * languageArray;
@property (strong, nonatomic) AudioHelper * helper;
@property (strong, nonatomic) NSIndexPath * currentlyPlayingCell;
@end
