//
//  LocationsViewController.m
//  5fish
//
//  Created by Ryan Canty on 1/15/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "ContinentsViewController.h"
#import "DataAccessLayer.h"
#import "CountriesViewController.h"

@interface ContinentsViewController ()

@end

@implementation ContinentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
            }
    return self;
}
-(void) home {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

  

    self.locationArray = [DataAccessLayer getContinents];
    self.title = @"Select Continent";
    
    UIButton * btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * imgHome = [UIImage imageNamed:@"home2.png"];
    btnHome.frame = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:btnHome];

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
    return [self.locationArray count];
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
    Location * loc = [self.locationArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = loc.defaultName;
    cell.imageView.image = [DataAccessLayer getImageById:loc.grn_id];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    // RegionsViewController *regionsVC = [[RegionsViewController alloc] init];
    CountriesViewController * countriesViewController = [[CountriesViewController alloc] initWithStyle:UITableViewStylePlain];
     // ...
     // Pass the selected object to the new view controller.
    
    
    
    Location * continent = [[self locationArray] objectAtIndex:[indexPath row]];
    NSMutableDictionary * subregions = [[NSMutableDictionary alloc] init];
    for(Location * region in [continent.relatedLocations allObjects]){
        NSMutableArray * countryArray = [[NSMutableArray alloc]init];
        for(Location * country in [region.relatedLocations allObjects]){
            if ([country.locationType isEqualToString: @"Country"]) {
                [countryArray addObject:country];
            }
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"defaultName" ascending:YES];
            NSArray * countries = [countryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            [subregions setObject:countries forKey:region.defaultName];
        }
    }
    for (NSString * key in [subregions allKeys]) {
        if ([[subregions objectForKey:key] count]==0) {
            [subregions removeObjectForKey:key];
        }
    }
    countriesViewController.subregions = subregions;
    //.regionArray = [continent.relatedLocations allObjects];
     [self.navigationController pushViewController:countriesViewController animated:YES];
    
}

@end
