//
//  ProgramRepository.h
//  5fish
//
//  Created by Ryan Canty on 1/12/13.
//  Copyright (c) 2013 GRN. All rights reserved.
//

#import "RepositoryBase.h"
#import "Program.h"
#import "VideoTrack.h"
#import "AudioTrack.h"
#import "Language.h"

@interface ProgramRepository : RepositoryBase

+(ProgramRepository*)sharedRepo; //Singleton

/*
 Retrieves all programs sorted by the grn_id. This method is currently not used in the application because the list of programs is too many to be useful. 
 */
-(NSArray*) getAllPrograms;

/*
 Retrieves a program object by the grn_id property.
 */
-(Program*) getProgramById:(NSInteger) grn_id;
/*
 To keep the layered architechture and no dependencies between the Repositories and Services, the Data Access Layer passes the JSON dictionary retrieved from WebServices to the Program repo to store it.
 */
-(BOOL) updateProgramWithId: (NSInteger) gid JsonDictionary:(NSDictionary*) jsonDict;

/*
 Deletes the audio and picture files associated with the program and sets its downloaded flag to NO
 */
-(BOOL) deleteProgramData: (Program*) program;

/*
 Sets the downladed flag for the specified program to be YES
 */
-(void) setProgramDownloaded:(Program*)program;

/*
 Retrieves the programs that have the Download flag set
 */
-(NSArray* )getDownloadedPrograms;

/*
 Returns whether the structure of the program, i.e. the data for the audio, etc. This is set when the user downloads the program.
 */
-(BOOL) isProgramStructureStored:(Program*)program;
@end
