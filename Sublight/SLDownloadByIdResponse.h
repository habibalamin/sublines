//
//  Created by Hemant Jangid on 05/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLDownloadByIdResponse : NSObject <NSXMLParserDelegate> {
	NSError *error;
    NSMutableString *currentXmlString;
	
    NSMutableString *resultString;
	NSMutableString *subtitleData;
	int points;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@property (nonatomic, readonly) NSString* subtitleData;
@property (nonatomic, readonly) int points;

@end
