//
//  Created by Hemant Jangid on 05/09/10 for Sublines.
//

#import "SLGetDownloadTicketResponse.h"
#import "SLExtensions.h"
#import "SLError.h"

@implementation SLGetDownloadTicketResponse

@synthesize ticket;
@synthesize queue;
@synthesize points;

- (id)init {
    if (self = [super init]) {
        currentXmlString = [[NSMutableString alloc] init];
        ticket = [[NSMutableString alloc] init];
		resultString = [[NSMutableString alloc] init];
		error = nil;
    }
    
    return self;
}

- (void)dealloc {
    [currentXmlString release];
    [ticket release];
	[resultString release];
    
    [super dealloc];
}

- (NSError*)parse:(NSData *)data {
	if ((data == nil) || ([data length] == 0)) {
		error = [SLError errorWithCode:SLFailed]; 
		return error;
	}
	
	NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:data];
	[xmlParser setDelegate:self];
	[xmlParser parse];
	return error;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[ticket setString:@""];
	[resultString setString:@""];
	queue = 0;
	points = 0;
	error = [SLError errorWithCode:SLFailed];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	error = [resultString isEqualToString:@"true"]? nil: [SLError errorWithCode:SLFailed];
	[parser release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	error = parseError;
	[parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [currentXmlString setString:@""]; //clear the xml string
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"ticket"]) {
		[ticket setString:[currentXmlString string]];
		return;
	}
	
	if ([elementName isEqualToString:@"que"]) {
		queue = [[currentXmlString string] intValue];
		return;
	}
	
	if ([elementName isEqualToString:@"points"]) {
		points = [[currentXmlString string] intValue];
		return;
	}
	
    if ([elementName isEqualToString:@"GetDownloadTicket2Result"]) {
		[resultString setString:[currentXmlString string]];
		return;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentXmlString appendString:string];
}

@end
