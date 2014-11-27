//
//  LanguageDetailViewController.m
//  5fish
//
//  Created by Ryan Canty on 1/22/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "LanguageDetailViewController.h"
#import "YoutubeViewController.h"
#import "Program.h"
#import "ProgramType.h"
#import "DataAccessLayer.h"
#import "AltName.h"
#import "Sample.h"

#define PROGRAM 0
#define ALTNAME 1
#define SAMPLE 2
@interface LanguageDetailViewController ()

@end

@implementation LanguageDetailViewController
@synthesize detailDict, selectedPrograms, downloadHelper, progressAlert, progressView, dialogAlert;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackProgressChanged:)
                                                     name:@"DownloadingAudio"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioDone:)
                                                     name:@"AudioDone"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(totalProgressChanged:)
                                                     name: @"TotalProgress"
                                                   object:nil];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedPrograms = [[NSMutableDictionary alloc]init];
    downloadHelper = [[DownloadHelper alloc]init];
    self.title = @"Programs";
    
    UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(downloadButtonAction)];
    self.navigationItem.rightBarButtonItem = downloadButton;
    
    progressView = [[DownloadProgressView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    progressAlert = [[RNBlurModalView alloc] initWithView: progressView];
    
    isProgressShowing = NO;
    userWarned = NO;
    
}
-(void)downloadButtonAction{
//    dialogAlert = [[UIAlertView alloc] initWithTitle:@"Download Programs"
//                                                      message:@"Would you like to download the selected programs to 'My Programs'?"
//                                                     delegate:self
//                                            cancelButtonTitle:@"No"
//                                            otherButtonTitles:@"Yes", nil];
//    [dialogAlert show];
    UIActionSheet * actions = [[UIActionSheet alloc] initWithTitle:@"Download selected programs to My Programs?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles: nil];
    [actions showInView:self.view];
}
//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if ([actionSheet.title isEqualToString:@"Download Programs"]) {
        
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"Cancelled");
    }else{
        
        NSLog(@"Sending selected programs to Download Helper");
        //sort and send programs to download to the download helper
        NSArray *sortedKeys = [[selectedPrograms allKeys] sortedArrayUsingSelector: @selector(compare:)];
        NSMutableArray *sortedValues = [NSMutableArray array];
        for (NSString *key in sortedKeys)
            [sortedValues addObject: [selectedPrograms objectForKey: key]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        @try {
            [downloadHelper downloadAudioFromPrograms: sortedValues];
            [progressAlert show];
            isProgressShowing = YES;
        }
        @catch (NSException *exception) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No internet connection" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }
       
        
    }

    
}

- (void) trackProgressChanged:(NSNotification*) notification{
    
    // Create the progress bar and add it to the alert
    if(!isProgressShowing){
        [progressAlert show];
        isProgressShowing = YES;
    }
    NSDictionary * userInfo = notification.userInfo;
    //NSLog(@"%@", [userInfo objectForKey:@"message"]);
    [progressView setMessage:[userInfo objectForKey:@"message"]];
    float percent = [[userInfo objectForKey:@"percent"] floatValue];
    [progressView setProgress:percent];

}

-(void)audioDone:(NSNotification*) notification{
    //[progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    [progressAlert hide];
    isProgressShowing = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[self navigationController] popToRootViewControllerAnimated:YES];
    if (![[notification object] boolValue]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Download Failed" message:@"The download has failed. Please try again and email the developer if the problem persists." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
}
-(void) totalProgressChanged:(NSNotification*) notification{
    float progress = [[notification object] floatValue];
    //[totProgressView setProgress:progress];
    [progressView setTotalProgress:progress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[detailDict allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case PROGRAM:
        {
            NSSet * programSet = [detailDict objectForKey:@"Program"];
            NSArray * array = [programSet allObjects];
            
            return [array count];
        }
        case ALTNAME:
            
            return [[[detailDict objectForKey:@"AltNames"] allObjects] count];
        case SAMPLE:
            return 1;
            
        default:
            NSLog(@"Section not rendered");
            return 0;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case PROGRAM:
            return @"Program Titles";
        case ALTNAME:
            return @"Alternative Language Names";
        case SAMPLE:
            return @"Sample Link";
            
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: CellIdentifier];
    }
    // Configure the cell...
    switch (section) {
        case PROGRAM:
        {
            NSSet * progSet = [detailDict objectForKey: @"Program"];
            NSArray * allPrograms = [progSet allObjects];
            Program *prog = [allPrograms objectAtIndex:row];
            
            if([selectedPrograms objectForKey:[NSNumber numberWithInt:[indexPath row]]] != nil)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            cell.imageView.image = [UIImage imageNamed:prog.type.pictureUrl];
            cell.textLabel.text = prog.title;
        }
            break;
        case ALTNAME:
        {
            NSSet * altSet = [detailDict objectForKey:@"AltNames"];
            NSArray * altArray = [altSet allObjects];
            AltName * name = [altArray objectAtIndex:row];
            cell.textLabel.text = name.altName;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.imageView.image = nil;
        }
            break;
        case SAMPLE:
        {
            Sample * sample = [detailDict objectForKey:@"Sample"];
            if (sample.youtube != nil) {
                cell.textLabel.text = [@"www.youtube.com/watch?v=" stringByAppendingString:sample.youtube];
            }else{
                cell.textLabel.text = @"No Youtube Sample Available";
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.imageView.image = nil;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == PROGRAM) {
        if (!userWarned) {
            if ([[selectedPrograms allKeys] count] >= 1) {
                UIAlertView * warning = [[UIAlertView alloc] initWithTitle:@"Caution!" message:@"Downloading more than 1 program can take a long time. Make sure you have a fast enough connection to handle it." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [warning show];
                userWarned = YES;
            }
        }
        
        //create temp dictionary for storing selected programs with index key and program value
        NSNumber * key = [NSNumber numberWithInt:[indexPath row]];
        NSSet * progSet = [detailDict objectForKey: @"Program"];
        NSArray * allPrograms = [progSet allObjects];
        Program *value = [allPrograms objectAtIndex:[indexPath row]];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            [selectedPrograms setObject:value forKey:key];
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [selectedPrograms removeObjectForKey:key];
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSLog(@"%@", [selectedPrograms allKeys]);
    } else if([indexPath section]==SAMPLE){
        Sample * sample = [detailDict objectForKey:@"Sample"];
        if (sample.youtube != nil) {
            YoutubeViewController *vc = [[YoutubeViewController alloc]init];
            vc.youtubeUrl = [@"http://www.youtube.com/watch?v=" stringByAppendingString:sample.youtube];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    
}

@end
