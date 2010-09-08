//
//  MediaInfo.m
//  CocoaTest
//
//  Created by Hemant Jangid on 28/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SLMediaInfo.h"
#import "MediaInfoDLL.h"
#import "SLError.h"

@interface SLMediaInfo ()

- (void)clear;

@end


@implementation SLMediaInfo

@synthesize targetFile;
@synthesize duration;

- (id)init {
	if (self = [super init]) {
		targetFile = [[NSMutableString alloc] init];
		[self clear];		
	}
	
	return self;
}

- (void)dealloc {
	[targetFile release];
	
	[super dealloc];
}

- (void)clear {
	duration = 0;
	[targetFile setString:@""];
}

- (NSError*)analyse:(NSString *)fileName {
	[self clear];
	
	[targetFile setString:fileName];
	
	if ([targetFile length] == 0)
		return [SLError errorWithCode:SLFileDoesNotExist];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL doesFileExist, isItDirectory;
	doesFileExist= [fileManager fileExistsAtPath:targetFile isDirectory:&isItDirectory];
	
	if (!doesFileExist)
		return [SLError errorWithCode:SLFileDoesNotExist];
	
	if (isItDirectory)
		return [SLError errorWithCode:SLInvalidFile];
	
	//Load library if not already loaded.	
	if (MediaInfoDLL_IsLoaded () < 1) {
		NSBundle* mainBundle = [NSBundle mainBundle];
		NSString* libraryPath = [mainBundle pathForResource:@"libmediainfo" ofType:@"dylib"];
		MediaInfoDLL_Load ([libraryPath cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	
	if (MediaInfoDLL_IsLoaded () < 1)
		return [SLError errorWithCode:SLInvalidFile];
	
	void* miHandle = MediaInfo_New ();
	
	@try {
		size_t openResult = MediaInfo_Open (miHandle, [targetFile cStringUsingEncoding:NSASCIIStringEncoding]);
		
		if (openResult != 1)
			return [SLError errorWithCode:SLInvalidFile];
		
		@try {
			const MediaInfo_Char* durationString = 
				MediaInfo_Get (miHandle, MediaInfo_Stream_Video, 0, "Duration/String3", MediaInfo_Info_Text, MediaInfo_Info_Name);
			
			DLog(@"Duration returned from library: %s", durationString);
			
			//Library returns blank string if given file is not media file
			if (strlen(durationString) == 0)
				return [SLError errorWithCode:SLInvalidFile];
			
			int hours, minutes, seconds, msecs;
			
			if(sscanf(durationString, "%d:%d:%d.%d", &hours, &minutes, &seconds, &msecs) != 4)
				return [SLError errorWithCode:SLInvalidOutputFromLibrary];
			
			duration = (hours * 60 + minutes) * 60 + seconds + 
					(msecs > 500? 1: (msecs < 500? 0: (seconds % 2)));
		}
		@finally {
			MediaInfo_Close (miHandle);
		}
	}
	@finally {
		MediaInfo_Delete (miHandle);
	}
	
	return nil;
}

@end
