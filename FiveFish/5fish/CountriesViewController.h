//
//  CountriesViewController.h
//  5fish
//
//  Created by Ryan Canty on 2/8/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Access the LocationRepository via DataAccessLayer to show the user the countries in their continent grouped by regions and sorted by name.
 */
#import <UIKit/UIKit.h>

@interface CountriesViewController : UITableViewController

@property (strong, nonatomic) NSDictionary * subregions;
@end
