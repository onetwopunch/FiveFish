//
//  MyProgramsViewController.m
//  FiveFish
//
//  Created by Ryan Canty on 2/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "MyProgramsViewController.h"
#import "Program.h"
#import "DataAccessLayer.h"
#import "AudioPlayerViewController.h"

@interface MyProgramsViewController ()

@end

@implementation MyProgramsViewController
@synthesize programsByLanguage;

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
    self.title = @"My Programs";
    programsByLanguage = [DataAccessLayer getDownloadedProgramsByLanguage];
    //NSLog(@"My Programs: %@", programsByLanguage);
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioPlayerViewController *audioVc = [[AudioPlayerViewController alloc] init];
    NSString *key = [[programsByLanguage allKeys] objectAtIndex:[indexPath section]];
    NSArray * programs = [programsByLanguage objectForKey:key];
    Program * prog = [programs objectAtIndex: [indexPath row]];
    audioVc.programId = prog.grn_id;
    audioVc.title = key;
    [self.navigationController pushViewController:audioVc animated:YES];
}

@end
