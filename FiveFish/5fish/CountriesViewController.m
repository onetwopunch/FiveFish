//
//  CountriesViewController.m
//  5fish
//
//  Created by Ryan Canty on 2/8/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "CountriesViewController.h"
#import "Location.h"
#import "LanguagesViewController.h"

@interface CountriesViewController ()

@end

@implementation CountriesViewController
@synthesize regionArray;

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

    self.title = @"Select Country";
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
    return [regionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Location * region = [regionArray objectAtIndex:section];
    return [region.relatedLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: CellIdentifier];
    }
    
    // Configure the cell...
    Location * region = [regionArray objectAtIndex:[indexPath section]];
    Location * country = [[region.relatedLocations allObjects] objectAtIndex:[indexPath row]];
    cell.textLabel.text = country.defaultName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Location *region = [regionArray objectAtIndex:section];
    return region.defaultName;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     LanguagesViewController *detailViewController = [[LanguagesViewController alloc] init];
    Location * region = [regionArray objectAtIndex:[indexPath section]];
    Location * country = [[region.relatedLocations allObjects] objectAtIndex:[indexPath row]];
    NSArray *languages = [country.languages allObjects];
    [detailViewController setLanguageArray:languages];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
