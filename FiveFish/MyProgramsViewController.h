//
//  MyProgramsViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 2/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Allows the user to view the programs they have downloaded grouped by language.
 */
#import <UIKit/UIKit.h>

@interface MyProgramsViewController : UITableViewController
@property(strong, nonatomic) NSDictionary * programsByLanguage;
@end
