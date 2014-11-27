//
//  AudioPlayerViewController.m
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "YoutubeViewController.h"
#import <MediaPlayer/MPMusicPlayerController.h>

@interface AudioPlayerViewController ()
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation AudioPlayerViewController
@synthesize audioControl, helper, timer, programId;


- (void)loadView
{
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackFinished:) name:@"TrackFinishedSuccessfully" object:nil];
    
	audioControl = [[AudioControlView alloc] initWithFrame:self.view.bounds];
    helper = [[AudioHelper alloc] init];
    [helper queueTracksForProgramId:[programId integerValue]];
    NSLog(@"Program ID Audio Ctrl: %d", [programId integerValue]);
    
    [self.view addSubview:audioControl];
    [audioControl.btnPlay addTarget:self action:@selector(play_pause) forControlEvents:UIControlEventTouchUpInside];
    [audioControl.btnNext addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [audioControl.btnPrevious addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    [audioControl.sldVolume addTarget:self action:@selector(volumeMoved:) forControlEvents:UIControlEventTouchUpInside];
    
    [audioControl.sldProgress addTarget:self action:@selector(progressTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [audioControl.sldProgress addTarget:self action:@selector(progressTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [helper prepareToPlay];
    audioControl.sldVolume.maximumValue = 1.0;
    audioControl.sldVolume.value = [self getSystemVolume];
    
    [self updateDisplay];
    
    if ([helper getYoutubeUrl] != nil) {
        UIButton * btnYoutube = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * img = [UIImage imageNamed:@"youtube.png"];
        btnYoutube.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [btnYoutube setImage: img forState:UIControlStateNormal];
        [btnYoutube addTarget:self action:@selector(youtube:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnYoutube];
    }
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [self pause];
}
-(void)updateDisplay{
    [audioControl setPlaying:[helper isPlaying]];
    audioControl.imgTrackPicture.image = [helper getCurrentImage];
    audioControl.lblTrackProgress.text = [helper getCurrentTime];
    audioControl.sldProgress.value = [helper getCurrentTimeValue];
    audioControl.sldProgress.maximumValue = [helper getDurationValue];
    audioControl.lblAlbumTitle.text = [helper getProgramTitle];
    audioControl.lblTrackTitle.text = [helper getTrackTitle];
    audioControl.lblTrackLength.text = [helper getDuration];
}
-(void)youtube:(id)sender{
    NSString * ref = [helper getYoutubeUrl];
    YoutubeViewController * vc = [[YoutubeViewController alloc] init];
    vc.youtubeUrl = [@"http://www.youtube.com/watch?v=" stringByAppendingString:ref];
    [self pause];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)play_pause{
    if ([audioControl isPlaying]) {
        [self pause];
    }else{
        [self play];
    }
}
-(void)play{
    [helper play];
    [self startTimer];
    [self updateDisplay];
    
}
-(void)pause{
    [helper pause];
    [self stopTimer];
    [self updateDisplay];
    
}
-(void)next{
    [helper next];
    [self startTimer];
    [self updateDisplay];
}
-(void)previous{
    [helper previous];
    [self startTimer];
    [self updateDisplay];
}
-(float)getSystemVolume{
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    float vol = iPod.volume;
    return vol;
}
-(void)volumeMoved:(UISlider*)sender{
    float vol = sender.value;
    [helper volume:vol];
}

-(void)progressTouchUpInside: (UISlider*)sender{
    NSLog(@"progress value: %f", sender.value);
    [helper stop];
    [helper setCurrentTime:sender.value];
    [self play];
}

-(void)progressTouchDown:(UISlider*)sender{
    if(self.timer)
        [self stopTimer];
    [self updateDisplay];
   
}

-(void)trackFinished:(NSNotification*)notification{
    if([[notification object] boolValue]){
        //next track queued up in service
        [self next];
        NSLog(@"Finished Successfully");
    }else {
        NSLog(@"Finished unsuccessfully");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Timer
- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}
-(void)startTimer{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                 target:self
                                               selector:@selector(timerFired:)
                                               userInfo:nil repeats:YES];
    }
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateDisplay];
}
@end
