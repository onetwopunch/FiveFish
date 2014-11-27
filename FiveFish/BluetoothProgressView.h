//
//  BluetoothProgressView.h
//  FiveFish
//
//  Created by Ryan Canty on 3/20/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This view is used in conjuction with the RNBlurModalView to show transfer progress of bluetooth. At the time of writing this documentation (4/8/2013) this view was not used because bluetooth transfer works synchronously and this progress view needs another thread to work properly.
 */

#import <UIKit/UIKit.h>

@interface BluetoothProgressView : UIView
@property (strong, nonatomic) UIProgressView * mTotalProgress;
@property (strong, nonatomic) UIProgressView * mProgress;
@property (strong, nonatomic) UILabel * msg;
-(void) setProgress:(float) progress;
-(void) setTotalProgress:(float) progress;
-(void) setMessage:(NSString *)message;
@end
