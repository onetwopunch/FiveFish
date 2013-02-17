//
//  WebServices.m
//  5fish
//
//  Created by Ryan Canty on 2/7/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "WebServices.h"
#import "AFHTTPRequestOperation.h"

#define kBgQueue        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define SUBREGIONS      @"https://secure.globalrecordings.net/feeds/subregions/1.json?v=1"
#define LANGUAGE_ALL    @"https://secure.globalrecordings.net/feeds/language/all.json?v=1"
#define LOCATION_ALL    @"https://secure.globalrecordings.net/xml/location-all.json?v=1"
#define PROGRAM         @"http://globalrecordings.net/xml/program/"

static NSOperationQueue * queue = nil;
@implementation WebServices

+(NSOperationQueue*) sharedQueue{
    if(queue == nil){
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        return queue;
    }else{
        return queue;
    }
}

+(void) downloadTracksFromProgramId:(NSInteger) grn_id WithFiles:(NSArray*) files WithBaseUrl: (NSString*) baseUrl{
        
    for (NSString *file in files) {
        
        NSString *urlPath = [NSString stringWithFormat:@"%@%@", baseUrl, file];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        //Create Folder for audio tracks if it isn't alread created
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"audio"];
        
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder if it doesn't already exist
        
        //Create folder for program if it is not already created
        NSString * programPath = [audioPath stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%05d", grn_id]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:programPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:programPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder if it doesn't already exist
        
        NSString *path = [programPath stringByAppendingPathComponent: file];
        
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
        
        //handle successful completion of each track download
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully downloaded file to %@", path);
            NSNotification * success = [NSNotification notificationWithName:@"TrackSuccess" object:[NSNumber numberWithBool: YES]];
            [[NSNotificationCenter defaultCenter] postNotification:success];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        //Send progress notification
        [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            //NSLog(@"Sent %lld of %lld bytes, %@", totalBytesWritten, totalBytesExpectedToWrite, path);
            
            float percentDone = ((float)((int)totalBytesWritten) / (float)((int)totalBytesExpectedToWrite));
            NSLog(@"Percent: %f", percentDone);
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:file, [NSNumber numberWithFloat: percentDone], nil]
                                                                  forKeys:[NSArray arrayWithObjects:@"message", @"percent", nil]];
            NSNotification * progress = [NSNotification notificationWithName:@"DownloadingAudio" object:nil userInfo:userInfo];
            [[NSNotificationCenter defaultCenter] postNotification:progress];
        }];
        
        [[self sharedQueue] addOperation:operation];
    }
}


+(NSDictionary*) getProgramStructureFromId: (NSInteger) progId{
    NSString *url =[[NSString alloc] initWithFormat:@"%@%05d%@",PROGRAM, progId, @"?v=2"];
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
