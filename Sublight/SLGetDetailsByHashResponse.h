//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLGetDetailsByHashResponse : NSObject<NSXMLParserDelegate> {
	NSMutableString *currentXmlString;
	NSError *error;
	
	NSMutableDictionary *imdbInfo;
	BOOL parsingImdbInfo;
	NSMutableString *resultString;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@property (nonatomic, readonly) NSDictionary *imdbInfo;

@end
