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

#define kBluetooth 0
#define kFacebook 1
#define kTwitter 2



@implementation ShareMenuViewController
@synthesize btHelper;

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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
            case kTwitter:
        {
            cell.textLabel.text = @"Twitter";
            cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    //[btHelper connect:session];
    
    picker.delegate = nil;
    [picker dismiss];
    
    BluetoothViewController * vc = [[BluetoothViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    [picker dismiss];
    picker.delegate = nil;
    BluetoothViewController * vc = [[BluetoothViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
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
            break;
        case kTwitter:
            break;
        default:
            break;
    }
}

@end
