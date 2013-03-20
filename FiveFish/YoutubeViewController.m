//
//  YoutubeViewController.m
//  FiveFish
//
//  Created by Ryan Canty on 3/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "YoutubeViewController.h"

@interface YoutubeViewController ()

@end

@implementation YoutubeViewController
@synthesize webView, youtubeUrl;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    webView = [[UIWebView alloc] initWithFrame:[self.navigationController.view frame]];
    [self.view addSubview:webView];
    //Create a URL object.
    NSLog(@"Url: %@", youtubeUrl);
    NSURL *url = [NSURL URLWithString:youtubeUrl];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    webView = nil;
    youtubeUrl = nil;
}

@end
