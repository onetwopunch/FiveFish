//
//  ShareMenuViewController.m
//  FiveFish
//
//  Created by Ryan Canty on 3/17/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "ShareMenuViewController.h"
#import <GameKit/GameKit.h>
#import "BluetoothViewController.h"
#import "FacebookViewController.h"
#import <Twitter/Twitter.h>

#define kBluetooth 0
#define kFacebook 1
#define kTwitter 2



@implementation ShareMenuViewController


GKPeerPickerController *picker;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch ([indexPath row]) {
        case kBluetooth:
        {
            cell.textLabel.text = @"Bluetooth";
            cell.imageView.image = [UIImage imageNamed:@"bluetooth.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
            case kFacebook:
        {
            cell.textLabel.text = @"Facebook";
            cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
            case kTwitter:
        {
            cell.textLabel.text = @"Twitter";
            cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
            
        default:
            break;
    }
    
    
    return cell;
}
#pragma mark - Picker delegate
- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *) session {
    
    [picker dismiss];
    picker.delegate = nil;
    picker = nil;
    
    
    BluetoothViewController * vc = [[BluetoothViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.btHelper = [[BluetoothHelper alloc] init];
    [vc.btHelper connect:session];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    [picker dismiss];
    picker = nil;
    picker.delegate = nil;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSString *postTxt = @"I just heard an amazing message from the 5Fish iOS app in my language! Go to http://5fish.mobi to hear it for yourself!";
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSInteger sysVersion = [[versionCompatibility objectAtIndex:0] intValue];
    switch ([indexPath row]) {
        case kBluetooth:
        {
            if (picker ==nil) {
                picker = [[GKPeerPickerController alloc] init];
                picker.delegate = self;
                picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
                [picker show];
            }
            break;
        }
        case kFacebook:
        {
            // if it is available to us, we will post using the native dialog
            [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO];            
            if(sysVersion >= 6){
                
          //      [FBNativeDialogs presentShareDialogModallyFrom:self initialText:postTxt image:nil url:nil                                                   handler:nil];
                SLComposeViewController *fbViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [fbViewController setInitialText:postTxt];
                [fbViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [self presentViewController:fbViewController animated:YES completion:nil];
            } else {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Pease update to iOS 6 to use the Facebook feature." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            }
            break;
        }
        case kTwitter:
        {
            [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
            if (sysVersion >=6) {
                
                SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                // Set the initial tweet text. See the framework for additional properties that can be set.
                [tweetViewController setInitialText:postTxt];
                
                // Create the completion handler block.
                [tweetViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                // Present the tweet composition view controller modally.
                [self presentViewController:tweetViewController animated:YES completion:nil];

            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Please install Twitter from the App Store to tweet." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            }
            break;
        }
        default:
            break;
    }
}

@end
