//
//  AudioControlView.m
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
#define BTN_HEIGHT 325
#import "GlossyView.h"
#import "AudioControlView.h"

@implementation AudioControlView

@synthesize btnPlay, btnNext, btnPrevious, sldVolume, sldProgress;
@synthesize lblAlbumTitle, lblTrackLength, lblTrackProgress, lblTrackTitle, imgTrackPicture;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        isPlaying = NO;
        
        //Top setup
        GlossyView *top =   [[GlossyView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 75)];
        [top setSeparation:32.5];
        lblTrackTitle = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+5, frame.size.width,20)];
        lblTrackTitle.textAlignment = NSTextAlignmentCenter;
        lblTrackTitle.text = @"Track Title";
        lblTrackTitle.font = [UIFont fontWithName:@"Arial" size:18.0f];
        lblTrackTitle.textColor = [UIColor whiteColor];
        lblTrackTitle.backgroundColor = [UIColor clearColor];
        
        lblAlbumTitle = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+25, frame.size.width, 15)];
        lblAlbumTitle.textAlignment = NSTextAlignmentCenter;
        lblAlbumTitle.text = @"Album Title";
        lblAlbumTitle.font = [UIFont fontWithName:@"Arial" size:12.0f];
        lblAlbumTitle.textColor = [UIColor whiteColor];
        lblAlbumTitle.backgroundColor = [UIColor clearColor];
        
        sldVolume = [[UISlider alloc] initWithFrame:CGRectMake(frame.origin.x+20, frame.origin.y+40, frame.size.width-40, 31)];
        UIImageView * lowVol = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+3, frame.origin.y+10, 30, 30)];
        [lowVol setImage:[UIImage imageNamed:@"volume_low.png"]];
        
        UIImageView * highVol = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width- 33, frame.origin.y+10, 30, 30)];
        [highVol setImage:[UIImage imageNamed:@"volume_high.png"]];
                
        //Bottom Setup
        GlossyView *bottom = [[GlossyView alloc] initWithFrame:CGRectMake(frame.origin.x, 160, frame.size.width, 200)];
        
        btnPrevious = [[UIButton alloc] initWithFrame:CGRectMake(25, BTN_HEIGHT, 30, 30)];
        [btnPrevious setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
        
        btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(150, BTN_HEIGHT, 30, 30)];
        [btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        btnNext = [[UIButton alloc] initWithFrame:CGRectMake(270, BTN_HEIGHT, 30, 30)];
        [btnNext setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        
        sldProgress = [[UISlider alloc] initWithFrame:CGRectMake(frame.origin.x+20, BTN_HEIGHT+35, frame.size.width-40, 31)];
        
        lblTrackProgress = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x+5, BTN_HEIGHT +60, 40, 20)];
        lblTrackProgress.font = [UIFont fontWithName:@"Arial" size:10.0f];
        lblTrackProgress.text = @"00:00:00";
        lblTrackProgress.textColor = [UIColor whiteColor];
        lblTrackProgress.backgroundColor = [UIColor clearColor];
        
        lblTrackLength = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-45, BTN_HEIGHT + 60, 40, 20)];
        lblTrackLength.font = [UIFont fontWithName:@"Arial" size:10.0f];
        lblTrackLength.text = @"99:59:59";
        lblTrackLength.textColor = [UIColor whiteColor];
        lblTrackLength.backgroundColor = [UIColor clearColor];
        
        //Center setup
        imgTrackPicture = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, top.frame.size.height, frame.size.width, 245)];
        [imgTrackPicture setImage:[UIImage imageNamed:@"five_fish_splash.png"]];
        //imgTrackPicture.contentMode = UIViewContentModeScaleAspectFit;
        
        

        [self addSubview:top];
        [self addSubview:lblTrackTitle];
        [self addSubview:lblAlbumTitle];
        [self addSubview:sldVolume];
        [self addSubview:lowVol];
        [self addSubview:highVol];

        [self addSubview:imgTrackPicture];
        
        [self addSubview:bottom];
        [self addSubview:btnPrevious];
        [self addSubview:btnPlay];
        [self addSubview:btnNext];
        [self addSubview:sldProgress];
        [self addSubview:lblTrackProgress];
        [self addSubview:lblTrackLength];
       
    }
    return self;
}
-(void) setPlaying:(BOOL) val{
    isPlaying = val;
    if (isPlaying) {
        [btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }else{
        [btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}
-(BOOL) isPlaying {
    return isPlaying;
}
@end
