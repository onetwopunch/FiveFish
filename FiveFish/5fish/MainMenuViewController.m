//
//  MainMenuViewController.m
//  5fish
//
//  Created by Ryan Canty on 2/10/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ContinentsViewController.h"
#import "DataAccessLayer.h"
#import "MyProgramsViewController.h"

#define LOAD_DATABASE 0


#define BTN_DOWNLOAD        CGRectMake(20, 163, 136, 44)
#define BTN_SHARE           CGRectMake(164, 163, 136, 44)
#define BTN_MY_PROGRAMS     CGRectMake(20, 230, 280, 44)

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize activityView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.title = @"Main Menu";
    
    //initial database copy
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
       
    }
    
    
    UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnDownload setFrame:BTN_DOWNLOAD];
    [btnDownload setTitle:@"Download" forState:UIControlStateNormal];
    [btnDownload addTarget:self action:@selector(downloadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShare setFrame:BTN_SHARE];
    [btnShare setTitle:@"Share" forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPlay setFrame:BTN_MY_PROGRAMS];
    [btnPlay setTitle:@"My Programs" forState:UIControlStateNormal];
    [btnPlay addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
//    //Used only for loading the database from json feeds
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.view addSubview:btnDownload];
    [self.view addSubview:btnPlay];
    [self.view addSubview:btnShare];
    
}

-(void) downloadButtonTapped{
    ContinentsViewController * vc = [[ContinentsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void) playButtonTapped{
    MyProgramsViewController * vc = [[MyProgramsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) shareButtonTapped{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Share" message:@"Share not yet implemented" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}
-(void) addButtonAction{

    if (LOAD_DATABASE) {
        activityView.center= CGPointMake(self.view.center.x, self.view.center.y-100);
        
        [activityView startAnimating];
        
        [self.view addSubview:activityView];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            @autoreleasepool {
                NSLog(@"Loading database from JSON feeds...");
                [DataAccessLayer initial_setLanguages];
                [DataAccessLayer initial_setLocationStructure];
                [DataAccessLayer initial_setLocations];

            }
            
            dispatch_async( dispatch_get_main_queue(), ^{
                [activityView stopAnimating];
                [activityView removeFromSuperview];
            });
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
