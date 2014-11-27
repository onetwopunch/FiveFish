//
//  BluetoothHelper.m
//  FiveFish
//
//  Created by Ryan Canty on 3/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "BluetoothHelper.h"
#import "BluetoothServices.h"

@implementation BluetoothHelper
@synthesize service;

-(void) connect: (GKSession*)session{
    service = [[BluetoothServices alloc] init];
    [service.mFileTransfer setSession:session];
    [service.mFileTransfer connect];
}
-(void) disconnect{
    [service.mFileTransfer disconnect];
}
-(void) shareProgram: (Program*) program{
    
    [service shareProgram:program];
}
@end
