//
//  GlossyView.h
//  FiveFish
//
//  Created by Ryan Canty on 3/2/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlossyView : UIView {
    float seperation;
}
@property (strong, nonatomic) UIView *top;
@property (strong, nonatomic) UIView *bottom;

-(void) setSeparation:(float) num;
-(void)setup:(CGRect) frame Sep: (float)sep;
@end
