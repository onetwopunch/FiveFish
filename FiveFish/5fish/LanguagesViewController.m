//
//  LanguagesViewController.m
//  5fish
//
//  Created by Ryan Canty on 1/15/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "LanguagesViewController.h"
#import "DataAccessLayer.h"
#import "LanguageDetailViewController.h"


@interface LanguagesViewController ()

@end

@implementation LanguagesViewController

@synthesize languageArray;


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
    
   // self.languageArray = [DataAccessLayer getAllLanguages];
   self.title = @"Select language";
    
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
    return [languageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
    }
    // Configure the cell...
    Language * language= [languageArray objectAtIndex:[indexPath row]];
//    NSLog(@"Cells: %@, %@, %@", [language defaultName], [language iso], [language grn_id]);
    cell.textLabel.text = [language defaultName];
    cell.detailTextLabel.text =[[language grn_id] stringValue];
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
    // Navigation logic may go here. Create and push another view controller.
    
    LanguageDetailViewController *detailViewController = [[LanguageDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    Language * language= [languageArray objectAtIndex:[indexPath row]];
    NSMutableDictionary * langDetails = [[NSMutableDictionary alloc] init];
    [langDetails setObject:[language program] forKey:@"Program"];
    [langDetails setObject:[language sample] forKey:@"Sample"];
    [langDetails setObject:[language altNames] forKey:@"AltNames"];
    [detailViewController setDetailDict:langDetails];
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}

@end
