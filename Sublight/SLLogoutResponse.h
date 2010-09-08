//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLLogoutResponse : NSObject<NSXMLParserDelegate> {
	NSMutableString *currentXmlString;
	NSError *error;
	NSMutableString *logoutResultString;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@end
