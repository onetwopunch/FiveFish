//
//  BluetoothServices.m
//  FiveFish
//
//  Created by Ryan Canty on 3/4/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "BluetoothServices.h"
#import "Program.h"
#import "AudioTrack.h"
#import "DataAccessLayer.h"
#import "WebServices.h"

static ACFileTransfer* fileTransfer = nil;

@implementation BluetoothServices

Program * mProgram = nil;

+(ACFileTransfer * )fileTransferInstance {
    if (fileTransfer == nil) {
        return [[ACFileTransfer alloc ] initWithDelegate:self];
    }else{
        return  fileTransfer;
    }
}

+(void) shareProgram: (Program *) program{
    //1. send json structure
    NSData * jsonData = [program.trackJsonString dataUsingEncoding:NSUTF8StringEncoding];
    [fileTransfer sendData:jsonData withFilename:@"JSON" toPeers:fileTransfer.peers];
    
    //2. send tracks from documents
    for (AudioTrack * track in program.audioTracks) {
        //send audio
        NSString * audioPath = [WebServices createAudioDir];
        NSString *programPath = [WebServices createProgramDir:audioPath WithId:[program.grn_id integerValue]];
        NSString *path = [programPath stringByAppendingPathComponent: track.file];
        [fileTransfer sendFile: path toPeers:fileTransfer.peers];
        
        //send picture
        NSString * picPath = [WebServices createPictureDir];
        programPath = [WebServices createProgramDir:picPath WithId:[program.grn_id integerValue]];
        path = [programPath stringByAppendingPathComponent:track.picture];
        [fileTransfer sendFile: path toPeers:fileTransfer.peers];
    }
    NSLog(@"Program shared");
}

#pragma mark - ACFileTransfer delegate methods
-(void)fileTransfer:(ACFileTransfer*)fileTransfer sentFile:(NSString*)file{
    //Send notification to UI
    NSLog(@"File sent: %@", file);
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer beganFile:(ACFileTransferDetails*)file{
    //Send notification to UI
    NSLog(@"File began: %@", file.filename);

}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer receivedFile:(ACFileTransferDetails*)file{
    if ([file.filename isEqualToString:@"JSON"]) {
        //get structure
        NSError * error;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:file.data options:kNilOptions error:&error];
        NSLog(@"JSON Dictionary: %@", jsonDict);
        
        //store structure
        NSInteger grnId = [[jsonDict objectForKey:@"grnId"] integerValue];
        mProgram = [DataAccessLayer getProgramById:grnId JsonDictionary:jsonDict];
        
    } else if (mProgram !=nil){
        //start receiving tracks
        NSString * extention = [file.filename pathExtension];
        if ([extention isEqualToString:@"mp3"]) {
            //if the file is audio
            [file.data writeToFile: file.filename atomically:YES];
            NSLog(@"Audio Track Received: %@", file.filename);
        } else if ( [extention isEqualToString:@"jpg"] || [extention isEqualToString:@"png"]){
            //if the file is an image
            [file.data writeToFile: file.filename atomically:YES];
            NSLog(@"Image Received: %@", file.filename);
        } else {
            NSLog(@"File name invalid: %@", file.filename);
        }
        
    } else {
        NSLog(@"Data not received in the proper format");
    }
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer failedFile:(ACFileTransferDetails*)file{
    //Send notification to UI
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer sentPacket:(ACFileTransferDetails*)packet{
    //Send notification to UI
    NSLog(@"Packet sent from %@", packet.filename);
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer receivedPacket:(ACFileTransferDetails*)packet{
    //Send notification to UI
    NSLog(@"Packet received named %@", packet.filename);
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer failedPacket:(ACFileTransferDetails*)packet{
    //Send notification to UI
    NSLog(@"Packet failed: %@", packet.filename);
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer updatedPeers:(NSArray*)peers{
    //Send notification to UI
}
-(void)fileTransfer:(ACFileTransfer*)fileTransfer changedAvailability:(BOOL)available{
    //Send notification to UI
}
@end
