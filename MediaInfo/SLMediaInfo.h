//
//  MediaInfo.h
//  CocoaTest
//
//  Created by Hemant Jangid on 28/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SLMediaInfo : NSObject {
	int duration;
	NSMutableString *targetFile;
}

- (id)init;
- (void)dealloc;

- (NSError*)analyse:(NSString*)fileName;

@property (readonly, nonatomic) NSString *targetFile;
@property (readonly, nonatomic) int duration;

@end
