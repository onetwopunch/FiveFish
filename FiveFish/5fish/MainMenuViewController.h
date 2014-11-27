//
//  MainMenuViewController.h
//  5fish
//
//  Created by Ryan Canty on 2/10/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This ViewController is used for the Main Menu and thus has three buttons and an animation. If you need to update the database as seen in WebServices.h, set DEBUG to 1 and uncomment the code that sets the rightBarButton. Then just tap that button to load the new database from the JSON feeds.
 */
#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController{
    
}
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImageView * splash;
@end
