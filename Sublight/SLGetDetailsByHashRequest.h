//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLGetDetailsByHashRequest : NSObject {
	NSString* placeHolder;
}

- (id)init;
- (void)dealloc;

- (NSData*)requestWithSession:(NSString*)session sublightHash:(NSString*)sublightHash;

@end
