//
//  BluetoothViewController.m
//  FiveFish
//
//  Created by Ryan Canty on 3/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "BluetoothViewController.h"
#import "DataAccessLayer.h"
#import "Program.h"

@implementation BluetoothViewController
@synthesize programsByLanguage, btHelper, progressView, progressAlert, progressAlertSend, progressAlertReceive;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //send bluetooth
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendProgress:) name:@"UpdateSend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotalSendProgress:) name:@"UpdateTotalSend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFinished:) name:@"Sent" object:nil];

    //receive bluetooth
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReceiveProgress:) name:@"UpdateReceive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotalReceiveProgress:) name:@"UpdateTotalReceive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFinished:) name:@"Received" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBegan:) name:@"ReceiveBegan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendBegan:) name:@"SendBegan" object:nil];
    
    
    self.title = @"Bluetooth Share";
    
//    progressView = [[BluetoothProgressView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
//    progressAlert =[[RNBlurModalView alloc] initWithView:progressView];

    progressAlertSend = [[RNBlurModalView alloc] initWithTitle:@"Please Wait" message:@"Sending data over Bluetooth may take a while"];
    progressAlertReceive = [[RNBlurModalView alloc] initWithTitle:@"Please Wait" message:@"Receving data over Bluetooth may take a while"];

    isProgressShowing = NO;
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;
    selectedSection = selectedRow = -1;
    programsByLanguage = [DataAccessLayer getDownloadedProgramsByLanguage];
    
    if ([[programsByLanguage allKeys] count] == 0) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No Programs"
                                                       message:@"You do not have any downloaded programs yet. Select your location and language from the 'Download' button in the Main Menu"
                                                      delegate:self
                                             cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
    
}
-(void) viewDidDisappear:(BOOL)animated{
    if (btHelper != nil) {
        [btHelper disconnect];
        btHelper = nil;
    }
}
-(void) share {
    if (selectedSection == -1 || selectedRow == -1) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Select Program to Share" message:@"Please select a program that you want to share over Bluetooth" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Share" message:@"Are you sure you want to share this program?" delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
        [alert show];
    }
}
-(void) sendBegan: (NSNotification*) notification{
    if (!isProgressShowing) {
        [progressAlertSend show];
        isProgressShowing = YES;
    }
}
-(void) updateSendProgress: (NSNotification*) notification{
//    if(!isProgressShowing){
//        [progressAlert show];
//        isProgressShowing = YES;
//        [progressView setMessage:@"Sending Program..."];
//    }
//    float progress = [[notification object] floatValue];
//    [progressView setProgress:progress];
}
-(void) updateTotalSendProgress: (NSNotification*) notification{
//    float progress = [[notification object] floatValue];
//    [progressView setTotalProgress:progress];
}
-(void) sendFinished: (NSNotification*) notification{
    [progressAlertSend hide];
    isProgressShowing = NO;
}
-(void) updateReceiveProgress: (NSNotification*) notification{
//    if(!isProgressShowing){
//        [progressAlert show];
//        isProgressShowing = YES;
//        [progressView setMessage:@"Receiveing Program..."];
//    }
//    float progress = [[notification object] floatValue];
//    [progressView setProgress:progress];
    
}
-(void) updateTotalReceiveProgress: (NSNotification*) notification{
//    float progress = [[notification object] floatValue];
//    [progressView setTotalProgress:progress];
}
-(void) receiveBegan: (NSNotification *) notification{
    if (!isProgressShowing) {
        [progressAlertReceive show];
        isProgressShowing = YES;
    }

}
-(void) receiveFinished: (NSNotification *) notification{
    [progressAlertReceive hide];
    isProgressShowing = NO;
    programsByLanguage = [DataAccessLayer getDownloadedProgramsByLanguage];
    [self.tableView reloadData];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && [alertView.title isEqualToString:@"Share"]) {
        NSString *key = [[programsByLanguage allKeys] objectAtIndex:selectedSection];
        NSArray * programs = [programsByLanguage objectForKey:key];
        Program * program = [programs objectAtIndex:selectedRow];
        
        [btHelper shareProgram:program];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[programsByLanguage allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [[programsByLanguage allKeys] objectAtIndex:section];
    NSArray * programs = [programsByLanguage objectForKey:key];
    return [programs count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[programsByLanguage allKeys] objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *key = [[programsByLanguage allKeys] objectAtIndex:[indexPath section]];
    NSArray * programs = [programsByLanguage objectForKey:key];
    Program * prog = [programs objectAtIndex: [indexPath row]];
    cell.textLabel.text = prog.title;
    cell.imageView.image = [UIImage imageNamed:prog.type.pictureUrl];
    if(selectedRow == [indexPath row] && selectedSection == [indexPath section])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedRow = [indexPath row];
        selectedSection = [indexPath section];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        selectedSection = selectedRow  = -1;
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
    }

}

@end
