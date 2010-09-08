//
//  Created by Hemant Jangid on 07/09/10 for CocoaSlate.
//

#import "SLUnzip.h"
#import "SLError.h"

@interface SLUnzip ()

- (void)randomize;
- (NSString*)stringWithUUID;
- (NSError*)unzip;

@end

@implementation SLUnzip

- (id)init {
	if (self = [super init]) {
		basePath = [[NSMutableString alloc] init];
		sourcePath = [[NSMutableString alloc] init];
		destPath = [[NSMutableString alloc] init];
		zipFile = [[NSMutableString alloc] init];
		fm = [NSFileManager defaultManager];
	}
	
	return self;
}

- (void)dealloc {
	[basePath release];
	[sourcePath release];
	[destPath release];
	[zipFile release];
	fm = nil;
	
	[super dealloc];
}

- (void)randomize {
	[basePath setString:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory (), [self stringWithUUID]]];
	[sourcePath setString:[NSString stringWithFormat:@"%@/Source", basePath]];
	[destPath setString:[NSString stringWithFormat:@"%@/Destination", basePath]];
	[zipFile setString:[NSString stringWithFormat:@"%@/File.zip", sourcePath]];	
}

- (NSString*)stringWithUUID {
	CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [uuidString autorelease];
}

NSInteger sort(id a, id b, void* p) {
    return [[a valueForKey:(NSString*)p] 
            compare:[b valueForKey:(NSString*)p]
            options:NSNumericSearch];
}

- (NSError*)unzip {
	NSTask *t = [[NSTask alloc] init];
	NSArray *args = [NSArray arrayWithObjects:zipFile, @"-d", destPath, nil];
	[t setLaunchPath:@"/usr/bin/unzip"];
	[t setArguments:args];
	[t setCurrentDirectoryPath:destPath];
	[t launch];
	[t waitUntilExit];
	
	int result = [t terminationStatus];
	[t release];
	
	return result == 0? nil: [SLError errorWithCode:SLUnableToUnzip];
}

- (NSError*)unzipSubtitles:(NSData*)data ofExtension:(NSString*)ext run:(NSString*)mediaFile {
	[self randomize];
	
	NSError *error = nil;
	BOOL success;
	
	success = [fm createDirectoryAtPath:sourcePath withIntermediateDirectories:YES attributes:nil error:&error];
	if (!success)
		return error;
	
	success = [fm createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:&error];
	if (!success)
		return error;
	
	success = [data writeToFile:zipFile options:NSDataWritingAtomic error:&error];
	if (!success)
		return error;
	
	error = [self unzip];
	if (error)
		return error;
	
	NSArray* extractedFiles = [fm contentsOfDirectoryAtPath:destPath error:&error];
	if (error)
		return error;
	
	if ([extractedFiles count] == 0)
		return [SLError errorWithCode:SLNoSubtitlesReceived];
	
	//Filter the extracted contents for subtitle files
	NSMutableArray *subtitleFiles = [[NSMutableArray alloc] init];
	@try {
		for (id f in [extractedFiles objectEnumerator]) {
			if (([f hasSuffix:ext]) && (![f hasPrefix:@"."]))
				[subtitleFiles addObject:f];
		}
		
		NSLog(@"%@", subtitleFiles);
		
		if ([subtitleFiles count] == 1) {
			//This is easy. Just copy the subtitle at movie location and run.
			NSString *src = [NSString stringWithFormat:@"%@/%@", destPath, [subtitleFiles objectAtIndex:0]];
			NSString *dst = [NSString stringWithFormat:@"%@.%@", [mediaFile stringByDeletingPathExtension], ext];
			
			//Remove the target file if exists. Don't bother about the error.
			[fm removeItemAtPath:dst error:NULL];
			success = [fm copyItemAtPath:src toPath:dst error:&error];
			if (!success)
				return error;
			
			success = [fm removeItemAtPath:basePath error:&error];
			if (!success)
				return error;
			
			[[NSWorkspace sharedWorkspace] openFile:mediaFile];
		}
		else {
			//Here comes the difficult part.
			//NSArray* sortedSubtitleFiles = [subtitleFiles sortedArrayUsingFunction:&sort context:@"title"];
			//TODO: Need to work out
			return [SLError errorWithCode:SLFailed];
		}		
	}
	@finally {
		[subtitleFiles release];
	}
	return nil;
}


@end
