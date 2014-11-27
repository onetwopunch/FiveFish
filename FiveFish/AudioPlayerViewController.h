//
//  AudioPlayerViewController.h
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 Leverages the AudioHelper to access the AudioServices and play the program in order of the tracks.
 */
#import <UIKit/UIKit.h>
#import "AudioControlView.h"
#import "AudioHelper.h"

@interface AudioPlayerViewController : UIViewController

@property (strong, nonatomic) AudioControlView * audioControl;
@property (strong, nonatomic) AudioHelper * helper;
@property (strong, nonatomic) NSNumber * programId;


-(void)setupTrack;
-(void)updateDisplay;

-(void)prepareToPlay;
-(void)play;
-(void)pause;
-(void)next;
-(void)previous;
-(float)getSystemVolume;
-(void)volumeMoved:(UISlider*)sender;
-(void)progressTouchDown:(UISlider*)sender;
-(void)progressTouchUpInside: (UISlider*)sender;
@end
