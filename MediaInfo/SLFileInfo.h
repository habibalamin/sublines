//
//  FileInfo.h
//  CocoaTest
//
//  Created by Hemant Jangid on 28/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SLFileInfo : NSObject {
	long size;
	NSMutableString *targetFile;
	NSMutableData *md5Hash;
}

-(id)init;
-(void)dealloc;

-(NSError*)analyse:(NSString*)fileName;

@property (readonly, nonatomic) NSString *targetFile;
@property (readonly, nonatomic) long size;
@property (readonly, nonatomic) NSMutableData *md5Hash;

@end
