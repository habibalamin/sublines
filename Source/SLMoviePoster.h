//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLMoviePoster : NSObject {
	NSString *imageUrl;
	NSString *imageUrlOrig;
	NSImage *imageData;
	NSString *imageId;
}

- (id)init;
- (void)dealloc;

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *imageUrlOrig;
@property (nonatomic, retain) NSImage *imageData;
@property (nonatomic, retain) NSString *imageId;

@end
