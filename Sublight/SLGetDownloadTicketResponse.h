//
//  Created by Hemant Jangid on 05/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLGetDownloadTicketResponse : NSObject <NSXMLParserDelegate> {
	NSError *error;
    NSMutableString *currentXmlString;
	
    NSMutableString *resultString;
	NSMutableString *ticket;
	int queue;
	int points;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@property (nonatomic, readonly) NSString* ticket;
@property (nonatomic, readonly) int queue;
@property (nonatomic, readonly) int points;

@end
