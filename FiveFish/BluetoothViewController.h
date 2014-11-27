//
//  BluetoothViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 3/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Accessed the BluetoothServices via BluetoothHelper to let the user connect and share programs with fellow FiveFish users.
 */
#import <UIKit/UIKit.h>
#import "BluetoothHelper.h"
#import "RNBlurModalView.h"
#import "BluetoothProgressView.h"

@interface BluetoothViewController : UITableViewController <UIAlertViewDelegate>{
    NSInteger selectedRow;
    NSInteger selectedSection;
    BOOL isProgressShowing;

}
@property (strong, nonatomic) NSDictionary * programsByLanguage;
@property (strong, nonatomic) BluetoothHelper * btHelper;
@property (strong, nonatomic) RNBlurModalView *progressAlert;
@property (strong, nonatomic) RNBlurModalView *progressAlertSend;
@property (strong, nonatomic) RNBlurModalView *progressAlertReceive;
@property (strong, nonatomic) BluetoothProgressView *progressView;
@end
