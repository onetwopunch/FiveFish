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
#import "ShareMenuViewController.h"

#define LOAD_DATABASE 0


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize activityView, splash;



- (void)viewDidLoad
{
    [super viewDidLoad];
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.title = @"Main Menu";
    
    
    
    UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * imgDownload = [UIImage imageNamed:@"download.png"];
    [btnDownload setFrame:CGRectMake(5, 5, imgDownload.size.width, imgDownload.size.height)];
    [btnDownload setImage: imgDownload forState:UIControlStateNormal];
    [btnDownload addTarget:self action:@selector(downloadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgPlay = [UIImage imageNamed:@"myprograms.png"];
    [btnPlay setFrame:CGRectMake(5, 140, imgPlay.size.width, imgPlay.size.height)];
    [btnPlay setImage:imgPlay forState:UIControlStateNormal];
    [btnPlay setTitle:@"My Programs" forState:UIControlStateNormal];
    [btnPlay addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgShare = [UIImage imageNamed:@"share.png"];
    [btnShare setFrame: CGRectMake(5, 285, imgShare.size.width, imgShare.size.height)];
    [btnShare setBackgroundColor:[UIColor clearColor]];
    [btnShare setImage:imgShare forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];

//    //Used only for loading the database from json feeds
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.view addSubview:btnDownload];
    [self.view addSubview:btnPlay];
    [self.view addSubview:btnShare];

    splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"five_fish_splash.png"]];
    [self animate];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self animate];
}
-(void)viewDidDisappear:(BOOL)animated{
    splash.frame = self.navigationController.view.frame;
}
-(void)animate{
    
    splash.frame = self.navigationController.view.frame;
    [self.view addSubview:splash];
    [UIView animateWithDuration:0.6f
                          delay:0.0f
                        options: nil
                        animations:^{
                         [splash setFrame:CGRectMake(150.0, self.navigationController.view.frame.origin.y,
                                                     self.navigationController.view.frame.size.width,
                                                     self.navigationController.view.frame.size.height)];
                         
                         
                     }
                     completion:nil];
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
    ShareMenuViewController * vc = [[ShareMenuViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
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
