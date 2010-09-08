//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>

@interface SLSearchResponse : NSObject <NSXMLParserDelegate> {
    NSMutableString* currentXmlString;
    NSMutableDictionary* subtitleDetails;
    BOOL parsingSubtitle;
	NSMutableString *resultString;
    
	NSError *error;
    NSMutableArray* subtitleList;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@property (nonatomic, readonly) NSArray* subtitleList;

@end
