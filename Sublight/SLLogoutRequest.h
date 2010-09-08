//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLLogoutRequest : NSObject {
	NSString* placeHolder;
}

- (id)init;
- (void)dealloc;

- (NSData*)requestWithSession:(NSString*)session;

@end
