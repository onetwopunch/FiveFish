//
//  BluetoothHelper.h
//  FiveFish
//
//  Created by Ryan Canty on 3/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//
/*
 This class gives the UI access to the Bluetooth services
 */
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ACFileTransfer.h"
#import "BluetoothServices.h"
#import "Program.h"

@interface BluetoothHelper : NSObject

@property (strong, nonatomic) BluetoothServices *service;
-(void) connect: (GKSession*)session;
-(void) disconnect;
-(void) shareProgram: (Program*) program;
@end
