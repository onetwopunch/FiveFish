//
//  LanguageDetailViewController.h
//  5fish
//
//  Created by Ryan Canty on 1/22/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadHelper.h"
#import "RNBlurModalView.h"
#import "DownloadProgressView.h"

@interface LanguageDetailViewController : UITableViewController{
    BOOL isProgressShowing;
}
@property (strong, nonatomic) NSDictionary * detailDict;
@property (strong, nonatomic) NSMutableDictionary * selectedPrograms;
@property (strong, nonatomic) DownloadHelper * downloadHelper;

@property (strong, nonatomic) UIAlertView * dialogAlert;
@property (strong, nonatomic) RNBlurModalView *progressAlert;
@property (strong, nonatomic) DownloadProgressView *progressView;

@end
