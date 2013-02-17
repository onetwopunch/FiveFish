//
//  ProgramDetailViewController.m
//  5fish
//
//  Created by Ryan Canty on 2/8/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "ProgramDetailViewController.h"
#import "AudioTrack.h"
#import "VideoTrack.h"
#import "MediaType.h"


@interface ProgramDetailViewController ()

@end

@implementation ProgramDetailViewController
@synthesize programDict;

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) 
        return @"Video";
    else
        return @"Audio";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;//[[programDict allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section ==0) 
        return 1;
    else
        return [[programDict objectForKey:@"audio"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
    }
    if ([indexPath section] == 0) {
        @try {
            VideoTrack * vid = [programDict objectForKey:@"video"];
            NSString * url = [[NSString alloc] initWithFormat:@"%@%@", vid.mediaType.baseUrl, vid.reference ];
            cell.textLabel.text = vid.mediaType.type;
            cell.detailTextLabel.text = url;
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
            cell.textLabel.text = [programDict objectForKey:@"video"];
        }
       
                
    }else{
        NSSet * audSet  = [programDict objectForKey:@"audio"];
        NSArray * audArray = [audSet allObjects];
        AudioTrack * aud = [audArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = aud.title;
        cell.detailTextLabel.text = aud.file;
    }
    
    
    //This code was from LanguageDetailVC to send the Dictionary to this VC
    
    //        NSSet * progSet = [detailDict objectForKey: @"Program"];
    //        NSArray * allPrograms = [progSet allObjects];
    //        Program * progFromLang=  [allPrograms objectAtIndex:[indexPath row]];
    //        Program * prog = [DataAccessLayer getProgramById:[progFromLang.grn_id intValue]];
    //
    //
    //        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    //        @try {
    //            if (prog.videoTrack !=nil)
    //                [dict setObject:[prog videoTrack] forKey:@"video"];
    //
    //            else
    //                [dict setObject:@"No Video" forKey:@"video"];
    //
    //            [dict setObject:[prog audioTracks] forKey:@"audio"];
    //            ProgramDetailViewController * detailViewController = [[ProgramDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //            detailViewController.programDict = dict;
    //            [self.navigationController pushViewController:detailViewController animated:YES];
    //        }
    //        @catch (NSException *exception) {
    //            NSLog(@"Unable to load Program data");
    //            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Web Connection Problem"
    //                                                              message:@"Unable to load program data from the web. Please check your web connection and try again."
    //                                                             delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //            [message show];
    
    //        }
    
    
    
    //    }
    
    
    
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
