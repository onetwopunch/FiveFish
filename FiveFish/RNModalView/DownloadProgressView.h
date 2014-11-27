//
//  DownloadProgressView.h
//  FiveFish
//
//  Created by Ryan Canty on 2/19/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This view is used in conjuction with the RNModalView to show download progress
 */
#import <UIKit/UIKit.h>

@interface DownloadProgressView : UIView
@property (strong, nonatomic) UIProgressView * mTotalProgress;
@property (strong, nonatomic) UIProgressView * mProgress;
@property (strong, nonatomic) UILabel * msg;
-(void) setProgress:(float) progress;
-(void) setTotalProgress:(float) progress;
-(void) setMessage:(NSString *)message;
@end
