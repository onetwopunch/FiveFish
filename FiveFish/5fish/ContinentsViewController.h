//
//  LocationsViewController.h
//  5fish
//
//  Created by Ryan Canty on 1/15/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Accesses the LocationRepository via DataAccessLayer to display the Continents with images as a table
 */
#import <UIKit/UIKit.h>

@interface ContinentsViewController : UITableViewController
@property (strong, nonatomic) NSArray* locationArray;
@end
