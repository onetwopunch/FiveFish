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



@implementation BluetoothServices
@synthesize mFileTransfer;
Program * mProgram = nil;

-(id)init{
    self = [super init];
    if (self) {
        mFileTransfer = [[ACFileTransfer alloc] initWithDelegate:self];
    }
    return self;
}

-(void) shareProgram: (Program *) program{
    //1. send json structure
    mProgram = program;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendBegan" object:nil userInfo:nil];
    NSData * jsonData = [program.trackJsonString dataUsingEncoding:NSUTF8StringEncoding];
    [mFileTransfer sendData:jsonData withFilename:@"JSON" toPeers:mFileTransfer.peers];
    
    //2. send tracks from documents
    for (AudioTrack * track in program.audioTracks) {
        //send audio
        NSString * audioPath = [WebServices createAudioDir];
        NSString *programPath = [WebServices createProgramDir:audioPath WithId:[program.grn_id integerValue]];
        NSString *path = [programPath stringByAppendingPathComponent: track.file];
        [mFileTransfer sendFile: path toPeers:mFileTransfer.peers];
        
        //send picture
        NSString * picPath = [WebServices createPictureDir];
        programPath = [WebServices createProgramDir:picPath WithId:[program.grn_id integerValue]];
        path = [programPath stringByAppendingPathComponent:track.picture];
        [mFileTransfer sendFile: path toPeers:mFileTransfer.peers];
    }
    NSLog(@"Program shared");
}

#pragma mark - ACFileTransfer delegate methods
-(void)fileTransfer:(ACFileTransfer*)fileTransfer sentFile:(NSString*)file{
    //Send notification to UI
    NSLog(@"File sent: %@", file);
    queueCount = [mProgram.audioTracks count];
    if (queueCount == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Sent" object:nil userInfo:nil];
    }else{
        float progress = ((float)[mProgram.audioTracks count]-(float)queueCount)/(float)queueCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTotalSent" object:[NSNumber numberWithFloat:progress] userInfo:nil];
    }
    queueCount --;
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer beganFile:(ACFileTransferDetails*)file{
    //Send notification to UI
    NSLog(@"File began: %@", file.filename);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveBegan" object:nil userInfo:nil];
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer receivedFile:(ACFileTransferDetails*)file{
    NSLog(@"File Received");
    
    if ([file.filename isEqualToString:@"JSON"]) {
        //get structure
        NSError * error;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:file.data options:kNilOptions error:&error];
        NSLog(@"JSON Dictionary: %@", jsonDict);
        
        //store structure
        NSInteger grnId = [[jsonDict objectForKey:@"grnId"] integerValue];
        mProgram = [DataAccessLayer getProgramById:grnId JsonDictionary:jsonDict];
        queueCount = [mProgram.audioTracks count];
        
    } else if (mProgram !=nil){
        
        //start receiving tracks
        NSString * extention = [file.filename pathExtension];
        if ([extention isEqualToString:@"mp3"]) {
            //if the file is audio
            NSString * audioPath = [WebServices createAudioDir];
            NSString *programPath = [WebServices createProgramDir:audioPath WithId:[mProgram.grn_id integerValue]];
            NSString *path = [programPath stringByAppendingPathComponent: file.filename];
            [file.data writeToFile: path atomically:YES];
            NSLog(@"Audio Track Received: %@", file.filename);
        } else if ( [extention isEqualToString:@"jpg"] || [extention isEqualToString:@"png"]){
            //if the file is an image
            NSString * picPath = [WebServices createPictureDir];
            NSString * programPath = [WebServices createProgramDir:picPath WithId:[mProgram.grn_id integerValue]];
            NSString * path = [programPath stringByAppendingPathComponent:file.filename];
            [file.data writeToFile: path atomically:YES];
            NSLog(@"Image Received: %@", file.filename);
        } else {
            NSLog(@"File name invalid: %@", file.filename);
        }
        
    } else {
        NSLog(@"Data not received in the proper format");
    }
    if (queueCount == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Received" object:nil userInfo:nil];
    } else {
        float progress = ((float)[mProgram.audioTracks count]-(float)queueCount)/(float)queueCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTotalReceived" object:[NSNumber numberWithFloat:progress] userInfo:nil];
    }
    queueCount--;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer failedFile:(ACFileTransferDetails*)file{
    //Send notification to UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedFileTransfer" object:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer sentPacket:(ACFileTransferDetails*)packet{
    //Send notification to UI
    NSLog(@"Packet sent from %@", packet.filename);
    float progress = (packet.bytes/packet.total);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSent"
                                                        object:[NSNumber numberWithFloat:progress]];
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer receivedPacket:(ACFileTransferDetails*)packet{
    //Send notification to UI
    NSLog(@"Packet received named %@", packet.filename);
    float progress = (packet.bytes/packet.total);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateReceived"
                                                        object:[NSNumber numberWithFloat:progress]];

}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer failedPacket:(ACFileTransferDetails*)packet{
    //Send notification to UI
    NSLog(@"Packet failed: %@", packet.filename);
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer updatedPeers:(NSArray*)peers{
    if ([peers count]==0)
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)fileTransfer:(ACFileTransfer*)fileTransfer changedAvailability:(BOOL)available{
    NSLog(@"Availability Changed");
}
@end
