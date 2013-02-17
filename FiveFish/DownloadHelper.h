//
//  DownloadHelper.h
//  FiveFish
//
//  Created by Ryan Canty on 2/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadHelper : NSObject{
    int counter;
}

-(void) downloadAudioFromPrograms: (NSArray*)programs;


@end
