//
//  BluetoothProgressView.m
//  FiveFish
//
//  Created by Ryan Canty on 3/20/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "BluetoothProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BluetoothProgressView
@synthesize mTotalProgress, mProgress, msg;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 15.f;
        self.layer.borderWidth = 3.f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f].CGColor;
        
        
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 31)];
        [title setCenter:CGPointMake(self.center.x, 20) ];
        [title setFont:[UIFont boldSystemFontOfSize:20]];
        [title setTextAlignment:NSTextAlignmentCenter];
        title.textColor = [UIColor whiteColor];
        title.text = @"Bluetooth Transfer Progress";
        title.backgroundColor = [UIColor clearColor];
        
        
        msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 31)];
        [msg setTextAlignment:NSTextAlignmentCenter];
        [msg setCenter:CGPointMake(self.center.x, 60)];
        msg.textColor = [UIColor whiteColor];
        msg.backgroundColor = [UIColor clearColor];
        
        mProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 90.0f, 225.0f, 90.0f)];
        
        
        UILabel * totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 31)];
        [totalLabel setCenter:CGPointMake(self.center.x, 130)];
        [totalLabel setTextAlignment:NSTextAlignmentCenter];
        totalLabel.text = @"Total Transfer Progress";
        totalLabel.textColor = [UIColor whiteColor];
        totalLabel.backgroundColor = [UIColor clearColor];
        
        mTotalProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 150.0f, 225.0f, 90.0f)];
        
        [mProgress setProgressViewStyle: UIProgressViewStyleBar];
        [mTotalProgress setProgressViewStyle:UIProgressViewStyleBar];
        
        [self addSubview:title];
        [self addSubview:msg];
        [self addSubview:mProgress];
        [self addSubview:totalLabel];
        [self addSubview:mTotalProgress];
        
        
    }
    return self;
}
-(void) setProgress:(float)progress{
    [mProgress setProgress:progress];
}
-(void) setTotalProgress:(float)progress{
    [mTotalProgress setProgress:progress];
}
-(void) setMessage:(NSString *)message{
    [msg setText:message];
}

@end
