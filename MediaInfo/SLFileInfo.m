//
//  FileInfo.m
//  CocoaTest
//
//  Created by Hemant Jangid on 28/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "SLFileInfo.h"
#import "SLError.h"

#define MEDIA_FILE_SIZE 5242880
#define MD5_HASH_LENGTH 16

@interface SLFileInfo ()

- (void)clear;

@end

@implementation SLFileInfo

@synthesize targetFile;
@synthesize size;
@synthesize md5Hash;

- (id)init {
	if (self = [super init]) {
		targetFile = [[NSMutableString alloc] init];
		md5Hash = [[NSMutableData alloc] initWithLength:MD5_HASH_LENGTH];
		[self clear];
	}
	
	return self;
}

- (void)dealloc {
	[targetFile release];
	[md5Hash release];
	
	[super dealloc];
}

- (void)clear {
	size = 0;
	[targetFile setString:@""];
	[md5Hash resetBytesInRange:NSMakeRange(0, [md5Hash length])];
}

- (NSError*)analyse:(NSString*)fileName {
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
	
	NSError* error = nil;
	NSDictionary* fileDetails = [fileManager attributesOfItemAtPath:targetFile error:&error];
	if (error != nil)
		return error;
	
	size = [fileDetails fileSize];
	
	if (size < MEDIA_FILE_SIZE)
		return [SLError errorWithCode:SLFileTooSmall];
	
	NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:targetFile];	
	NSData* fileData = [fileHandle readDataOfLength:MEDIA_FILE_SIZE];
	CC_MD5 ([fileData bytes], [fileData length], [md5Hash mutableBytes]);
	
	return nil; //success
}

@end
