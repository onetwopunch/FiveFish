//
//  YoutubeViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 3/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Subclass of UIWebView that lets the user navigates the user to a specific YouTube link.
 */
#import <UIKit/UIKit.h>

@interface YoutubeViewController : UIViewController
@property (nonatomic, retain) UIWebView * webView;
@property (nonatomic, strong) NSString * youtubeUrl;
@end
