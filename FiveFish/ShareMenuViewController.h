//
//  ShareMenuViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 3/17/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothHelper.h"

@interface ShareMenuViewController : UITableViewController
@property (strong, nonatomic) BluetoothHelper * btHelper;
@end
