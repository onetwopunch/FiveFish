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
@synthesize programsByLanguage, btHelper;


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
    self.title = @"Bluetooth Share";
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;

    selectedSection = selectedRow = -1;
    programsByLanguage = [DataAccessLayer getDownloadedProgramsByLanguage];
    
    if ([[programsByLanguage allKeys] count] == 0) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No Programs"
                                                       message:@"You do not have any downloaded programs yet. Select your location and language from the 'Download' button in the Main Menu"
                                                      delegate:self
                                             cancelButtonTitle:@"Return to Main Menu" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"No Programs"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
-(void) share {
    if (selectedSection == -1 || selectedRow == -1) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Select Program to Share"
                                                       message:@"Please select a program that you want to share over Bluetooth"
                                                      delegate:self
                                             cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    } else {
        NSString *key = [[programsByLanguage allKeys] objectAtIndex:selectedSection];
        Program * program = [programsByLanguage objectForKey:key];
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
