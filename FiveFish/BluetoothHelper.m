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

-(void) connect: (GKSession*)session{
    [[BluetoothServices fileTransferInstance] setSession:session];
    [[BluetoothServices fileTransferInstance] connect];
}

-(void) shareProgram: (Program*) program{
    [BluetoothServices shareProgram:program];
}
@end
