//
//  GlossyView.m
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "GlossyView.h"

@implementation GlossyView
@synthesize top, bottom;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame Sep:frame.size.height/4];
    }
    return self;
}

-(void) setSeparation:(float) num{
    [self setup:self.frame Sep:num];
    
}

-(void)setup:(CGRect) frame Sep:(float)sep{
    seperation = sep;
    top = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, seperation)];
    [top setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1]];
    
    bottom = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+seperation, frame.size.width, frame.size.height-seperation)];
    [bottom setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    
    [self addSubview:top];
    [self addSubview:bottom];
}

@end
