//
//  BluetoothServices.h
//  FiveFish
//
//  Created by Ryan Canty on 3/4/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

/*
 This class uses the ACFileTransfer 3rd party framework to transfer files over bluetooth as checksummed packets.
 ACFileTransfer leverages the GameKit native framework. GameKit sends generic NSData over blutooth connectiion,
 and ACFileTransfer spilts the file data into manageable packets to send entire files.
 
 The way I have used it is to first send the structure of the Program so it can be parsed into CoreData the same way it's done when downloading. Then once the program structure is sent, the audio and picture files are sent.
 
 To see more docs on ACFileTransfer: https://github.com/jkichline/ACConnect/wiki/ACFileTransfer
 */

#import <Foundation/Foundation.h>
#import "ACFileTransfer.h"
#import "Program.h"

@interface BluetoothServices : NSObject <ACFileTransferDelegate>{
    int queueCount;
}
@property (strong, nonatomic) ACFileTransfer* mFileTransfer;


-(void) shareProgram: (Program *) program;

@end
