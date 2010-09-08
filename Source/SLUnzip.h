//
//  Created by Hemant Jangid on 07/09/10 for CocoaSlate.
//

#import <Cocoa/Cocoa.h>


@interface SLUnzip : NSObject {
	NSFileManager *fm;
	NSMutableString *basePath;
	NSMutableString *sourcePath;
	NSMutableString *destPath;
	NSMutableString *zipFile;
}

- (id)init;
- (void)dealloc;

- (NSError*)unzipSubtitles:(NSData*)data ofExtension:(NSString*)ext run:(NSString*)mediaFile;

@end
