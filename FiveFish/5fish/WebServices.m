//
//  WebServices.m
//  5fish
//
//  Created by Ryan Canty on 2/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "WebServices.h"
#import "AFHTTPRequestOperation.h"
#import "Program.h"
#import "AudioTrack.h"
#import "DataAccessLayer.h"

#define kBgQueue        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define SUBREGIONS      @"https://secure.globalrecordings.net/feeds/subregions/1.json?v=1"
#define LANGUAGE_ALL    @"https://secure.globalrecordings.net/feeds/language/all.json?v=1"
#define LOCATION_ALL    @"https://secure.globalrecordings.net/xml/location-all.json?v=1"
#define TRACKS          @"https://secure.globalrecordings.net/feeds/track/"
#define PROGRAM         @"http://globalrecordings.net/xml/program/"



@implementation WebServices
@synthesize queue;

-(id) init{
    self = [super init];
    if(self){
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        queueSize = 0;
    }
    return self;
}



-(void) downloadTracksFromProgramArray:(NSArray*) programs{
    
    for (Program * program in programs) {
        Program * updatedProg = [DataAccessLayer getProgramById:[program.grn_id intValue]];
        NSMutableArray * trackFiles = [[NSMutableArray alloc] init];
        NSMutableArray * picFiles = [[NSMutableArray alloc] init];
        for (AudioTrack* track in [updatedProg.audioTracks allObjects]) {
            @try {
                [trackFiles addObject:[track file]];
                [picFiles addObject:[track picture]];
            }
            @catch (NSException *exception) {
                NSLog(@"Picture or Audio is nil");
            }
        }
        NSString * baseAudio = updatedProg.baseAudio;
        NSString * basePic = updatedProg.basePic;
        NSInteger grn_id = [updatedProg.grn_id integerValue];
        
        for (NSString*pic  in picFiles) {
            NSString * safeFile = [pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * urlPath = [NSString stringWithFormat:@"%@%@", basePic, safeFile];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            NSString * picPath = [[self class] createPictureDir];
            NSString *programPath = [[self class] createProgramDir:picPath WithId:grn_id];
            
            NSString *path = [programPath stringByAppendingPathComponent: pic];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
            [queue addOperation:operation];
        }
        
        
        for (NSString *file in trackFiles) {
            NSString * safeFile = [file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * urlPath = [NSString stringWithFormat:@"%@%@", baseAudio, safeFile];
          
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            NSString * audioPath = [[self class] createAudioDir];
            
            NSString *programPath = [[self class] createProgramDir:audioPath WithId:grn_id];
            
            NSString *path = [programPath stringByAppendingPathComponent: file];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
            
            
            //handle successful completion of each track download
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Successfully downloaded file to %@", path);
                if ([[queue operations] count] ==0) {
                    NSNotification * success = [NSNotification notificationWithName:@"AudioDone" object:[NSNumber numberWithBool: YES]];
                    [[NSNotificationCenter defaultCenter] postNotification:success];
                    queueSize = 0;
                } else {
                    //send total track info
                    
                    //get total queue size by the first success and add 1 back
                    if (queueSize ==0) {
                        queueSize = [[queue operations] count] +1.0;
                    }
                    float progress = (float)(queueSize-[[queue operations] count])/queueSize;
                    NSNumber * totProgress = [NSNumber numberWithFloat:progress];
                    NSLog(@"Total Progress: %@", totProgress);
                    NSNotification * totalProgressNotification = [NSNotification notificationWithName:@"TotalProgress"
                                                                                               object:totProgress];
                    [[NSNotificationCenter defaultCenter] postNotification:totalProgressNotification];
                }
                NSLog(@"QueueCount: %d", [[queue operations] count]); //[[self sharedQueue] operationCount]);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                NSNotification * failure = [NSNotification notificationWithName:@"AudioDone" object:[NSNumber numberWithBool: NO]];
                [[NSNotificationCenter defaultCenter] postNotification:failure];
            }];
            
            //Send progress notification
            [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                //NSLog(@"Sent %lld of %lld bytes, %@", totalBytesWritten, totalBytesExpectedToWrite, path);
                
                float percentDone = ((float)((int)totalBytesWritten) / (float)((int)totalBytesExpectedToWrite));
                //NSLog(@"Percent: %f", percentDone);
                NSDictionary * userInfo = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:file, [NSNumber numberWithFloat: percentDone], nil]
                                                                      forKeys:[NSArray arrayWithObjects:@"message", @"percent", nil]];
                NSNotification * progress = [NSNotification notificationWithName:@"DownloadingAudio" object:nil userInfo:userInfo];
                [[NSNotificationCenter defaultCenter] postNotification:progress];
            }];
            [queue addOperation:operation];
            //NSLog(@"Operation Queue: %@", [self sharedQueue]);
        }
    }
}


+(NSString*)createAudioDir{
    //Create Folder for audio tracks if it isn't alread created
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"audio"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder if it doesn't already exist
    return audioPath;
}
+(NSString*)createPictureDir{
    //Create Folder for audio tracks if it isn't alread created
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *picturePath = [documentsDirectory stringByAppendingPathComponent:@"pictures"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:picturePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:picturePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder if it doesn't already exist
    return picturePath;
}
+(NSString*)createProgramDir:(NSString*)basePath WithId: (NSInteger) grn_id{
    //Create folder for program if it is not already created
    NSString * programPath = [basePath stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%05d", grn_id]];
    NSError * error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:programPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:programPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder if it doesn't already exist
    return programPath;
}
+(NSDictionary*) getProgramStructureFromId: (NSInteger) progId{
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * iso = ([language isEqualToString:@"fr"]) ? @"fr" : @"en";
    NSString *url =[[NSString alloc] initWithFormat:@"%@%05d?v=10&app=7&i=%@",TRACKS, progId, iso];
    NSLog(@"Url: %@", url);
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    if (data !=nil) {
        NSError* error;
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }else {
        NSLog(@"Server Data for program id, %d is Null", progId);
    }
    return nil;
}
+(NSDictionary*) getProgramStructureFromIdCompat: (NSInteger) progId{
    NSString *url =[[NSString alloc] initWithFormat:@"%@%05d%@",PROGRAM, progId, @"?v=2"];
    NSLog(@"Compat URL: %@", url);
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    if (data !=nil) {
        NSError* error;
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }else {
        NSLog(@"Server Data for program id, %d is Null", progId);
    }
    return nil;
}
+(NSDictionary *) getSubregions{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:SUBREGIONS]];
    if (data !=nil) {
        NSError* error;
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }else {
        NSLog(@"Server Data for Subregions is Null");
    }
    return nil;
}

+(NSDictionary *) getAllLocations{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:LOCATION_ALL]];
    if (data !=nil) {
        NSError* error;
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }else {
        NSLog(@"Server Data for Locations is Null");
    }
    return nil;
}

+(NSDictionary *) getAllLanguages{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:LANGUAGE_ALL]];
    if (data !=nil) {
        NSError* error;
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }else {
        NSLog(@"Server Data for Languages is Null");
    }
    return nil;
}




@end
