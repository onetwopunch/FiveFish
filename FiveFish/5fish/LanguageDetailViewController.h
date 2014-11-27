//
//  LanguageDetailViewController.h
//  5fish
//
//  Created by Ryan Canty on 1/22/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Shows the user the datails of the Language they selected. This includes all programs, alternate language names, and if a youtube sample is associated. This is where the user opts to download programs and accesses the WebServices via the DownloadHelper.
 */
#import <UIKit/UIKit.h>
#import "DownloadHelper.h"
#import "RNBlurModalView.h"
#import "DownloadProgressView.h"

@interface LanguageDetailViewController : UITableViewController <UIActionSheetDelegate>{
    BOOL isProgressShowing;
    BOOL userWarned;
}
@property (strong, nonatomic) NSDictionary * detailDict;
@property (strong, nonatomic) NSMutableDictionary * selectedPrograms;
@property (strong, nonatomic) DownloadHelper * downloadHelper;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIAlertView * dialogAlert;
@property (strong, nonatomic) RNBlurModalView *progressAlert;
@property (strong, nonatomic) DownloadProgressView *progressView;

@end
