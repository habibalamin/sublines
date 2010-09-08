//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import "SLLogoutResponse.h"
#import "SLError.h"

@implementation SLLogoutResponse

- (id)init {
	if (self = [super init]) {
		currentXmlString = [[NSMutableString alloc] init];
		logoutResultString = [[NSMutableString alloc] init];
		error = nil;
	}
	
	return self;
}

- (void)dealloc {
	[currentXmlString release];
	[logoutResultString release];
	
	[super dealloc];
}

- (NSError*)parse:(NSData*)data {
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
	error = [SLError errorWithCode:SLFailed];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	error = [logoutResultString isEqualToString:@"true"]? nil: [SLError errorWithCode:SLFailed];
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
    if ([elementName isEqualToString:@"LogOutResult"]) {
		[logoutResultString setString:currentXmlString];
		return;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentXmlString appendString:string];
}

@end
