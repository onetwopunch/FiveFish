//
//  DownloadHelper.h
//  FiveFish
//
//  Created by Ryan Canty on 2/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This class gives the UI access to the WebServices to download programs asynchronously
 */
#import <Foundation/Foundation.h>

@interface DownloadHelper : NSObject

-(void) downloadAudioFromPrograms: (NSArray*)programs;


@end
