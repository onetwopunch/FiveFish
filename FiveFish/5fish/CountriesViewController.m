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
#import "DataAccessLayer.h"

@interface CountriesViewController ()

@end

@implementation CountriesViewController
@synthesize subregions;

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
    
    UIButton * btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * imgHome = [UIImage imageNamed:@"home2.png"];
    btnHome.frame = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:btnHome];

   

}
-(void) home{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return [[subregions allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString * key = [[subregions allKeys] objectAtIndex:section];
    return [[subregions objectForKey:key] count];
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
    //Location * region = [regionArray objectAtIndex:[indexPath section]];
    NSString * key = [[subregions allKeys] objectAtIndex:[indexPath section]];
//    Location * country = [[region.relatedLocations allObjects] objectAtIndex:[indexPath row]];
    NSArray * countries = [subregions objectForKey:key];
    Location * country = [countries objectAtIndex:[indexPath row]];
    cell.textLabel.text = country.defaultName;
    cell.imageView.image = [DataAccessLayer getFlagImageByCode:country.countryCode];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    Location *region = [regionArray objectAtIndex:section];
//    return region.defaultName;
    NSArray * keys = [subregions allKeys];
    return [keys objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     LanguagesViewController *detailViewController = [[LanguagesViewController alloc] init];
    //Location * region = [regionArray objectAtIndex:[indexPath section]];
    NSString * key = [[subregions allKeys] objectAtIndex:[indexPath section]];
    NSArray * countries= [subregions objectForKey:key];
    Location * country = [countries objectAtIndex:[indexPath row]];//[[region.relatedLocations allObjects] objectAtIndex:[indexPath row]];
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"defaultName" ascending:YES];
    NSArray * languages = [country.languages sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [detailViewController setLanguageArray:languages];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
