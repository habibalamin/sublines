//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLLoginAnonymousRequest : NSObject {
	NSString* placeHolder;
}

- (id)init;
- (void)dealloc;

- (NSData*)requestWithClientId: (NSString*)clientId apiKey:(NSString*)apiKey args:(NSArray*)args;

@end
