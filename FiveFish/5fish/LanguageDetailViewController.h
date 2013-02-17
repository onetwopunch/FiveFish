//
//  LanguageDetailViewController.h
//  5fish
//
//  Created by Ryan Canty on 1/22/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadHelper.h"

@interface LanguageDetailViewController : UITableViewController{
    BOOL isProgressShowing;
}
@property (strong, nonatomic) NSDictionary * detailDict;
@property (strong, nonatomic) NSMutableDictionary * selectedPrograms;
@property (strong, nonatomic) DownloadHelper * downloadHelper;

@property (strong, nonatomic) UIAlertView *progressAlert;
@property (strong, nonatomic) UIProgressView *progressView;
@end
