//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "SLError.h"

@interface SLLoginAnonymousResponse : NSObject<NSXMLParserDelegate> {
	NSMutableString *currentXmlString;
	NSError *error;

	BOOL parsingSettings;
	
	NSMutableString *session;
	NSMutableArray *settings;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@property (nonatomic, readonly) NSString *session;
@property (nonatomic, readonly) NSArray *settings;

@end
