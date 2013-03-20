//
//  BluetoothHelper.h
//  FiveFish
//
//  Created by Ryan Canty on 3/18/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ACFileTransfer.h"
#import "Program.h"

@interface BluetoothHelper : NSObject
-(void) connect: (GKSession*)session;
-(void) shareProgram: (Program*) program;
@end
