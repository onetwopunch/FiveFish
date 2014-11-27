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

@synthesize languageArray, helper, timer, currentlyPlayingCell;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        helper = [[AudioHelper alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sampleDidFinish:) name:@"SampleFinished" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   self.title = @"Select language";
    
    UIButton * btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * imgHome = [UIImage imageNamed:@"home2.png"];
    btnHome.frame = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:btnHome];

    
}
-(void)viewDidDisappear:(BOOL)animated{
    [helper stopAudioLanguageSample];
}
-(void)home {
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
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: CellIdentifier];
    }
    // Configure the cell...
    Language * language= [languageArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [language defaultName];
    cell.accessoryView = (currentlyPlayingCell == indexPath)
        ? [self makeDetailDisclosureButton:@"tablePause.png"]
        : [self makeDetailDisclosureButton:@"tablePlay.png"];
    
    return cell;
}

- (UIButton *) makeDetailDisclosureButton:(NSString *)img
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * btnImage = [UIImage imageNamed:img];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget: self
               action: @selector(accessoryButtonTapped:withEvent:)
     forControlEvents: UIControlEventTouchUpInside];
    
    return ( button );
}
- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:
                               [[[event touchesForView: button] anyObject] locationInView: self.tableView]];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ( indexPath == nil )
        return;

    if ([currentlyPlayingCell isEqual:indexPath]) {
        
        [helper stopAudioLanguageSample];
        currentlyPlayingCell = nil;
        cell.accessoryView = [self makeDetailDisclosureButton:@"tablePlay.png"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return;
    }
    if(currentlyPlayingCell != nil){
        [helper stopAudioLanguageSample];
        UITableViewCell * previousCell = [self.tableView cellForRowAtIndexPath:currentlyPlayingCell];
        previousCell.accessoryView = [self makeDetailDisclosureButton:@"tablePlay.png"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        currentlyPlayingCell = nil;
    }
    Language * language= [languageArray objectAtIndex:[indexPath row]];
    if ([helper playAudioLanguageSample:[language.grn_id integerValue]]) {
        cell.accessoryView = [self makeDetailDisclosureButton:@"tablePause.png"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        currentlyPlayingCell = indexPath;

    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Sample" message:@"There is no sample available for this language" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }

    
    //[self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

-(void) sampleDidFinish:(NSNotification*)notification{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:currentlyPlayingCell];
    cell.accessoryView = [self makeDetailDisclosureButton:@"tablePlay.png"];
    currentlyPlayingCell = nil;

}
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
