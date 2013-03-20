//
//  YoutubeViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 3/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeViewController : UIViewController
@property (nonatomic, retain) UIWebView * webView;
@property (nonatomic, strong) NSString * youtubeUrl;
@end
