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

-(BOOL) addProgram: (Program*)prog;
-(BOOL) removeProgram: (Program*)prog;
-(NSArray*) getAllPrograms;
-(Program*) getProgramById:(NSInteger) grn_id;
-(BOOL) updateProgramWithId: (NSInteger) gid;
-(NSArray* )getDownloadedPrograms;
-(BOOL) isProgramStructureStored:(Program*)program;
@end
