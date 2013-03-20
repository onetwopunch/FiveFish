//
//  BluetoothServices.h
//  FiveFish
//
//  Created by Ryan Canty on 3/4/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACFileTransfer.h"
#import "Program.h"

@interface BluetoothServices : NSObject
+(ACFileTransfer * )fileTransferInstance;
+(void) shareProgram: (Program *) program;
@end
