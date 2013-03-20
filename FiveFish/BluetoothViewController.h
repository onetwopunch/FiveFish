//
//  BluetoothViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 3/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothHelper.h"

@interface BluetoothViewController : UITableViewController{
    NSInteger selectedRow;
    NSInteger selectedSection;
}
@property (strong, nonatomic) NSDictionary * programsByLanguage;
@property (strong, nonatomic) BluetoothHelper * btHelper;
@end
