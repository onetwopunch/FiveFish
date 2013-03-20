//
//  AudioControlView.h
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioControlView : UIView{
    BOOL isPlaying;
}

/*
 This View gives the template of an Audio player for the view controller to add actions to
 */

@property (strong, nonatomic) UIButton * btnPlay;
@property (strong, nonatomic) UIButton * btnNext;
@property (strong, nonatomic) UIButton * btnPrevious;
@property (strong, nonatomic) UISlider * sldVolume; //Position on top
@property (strong, nonatomic) UISlider * sldProgress; //Position on bottom
@property (strong, nonatomic) UILabel  * lblTrackLength;
@property (strong, nonatomic) UILabel  * lblTrackProgress;
@property (strong, nonatomic) UILabel  * lblTrackTitle;
@property (strong, nonatomic) UILabel  * lblAlbumTitle;
@property (strong, nonatomic) UIImageView * imgTrackPicture;


-(BOOL) isPlaying;
-(void) setPlaying:(BOOL) val;
@end
