//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import "SLGetDetailsByHashResponse.h"
#import "SLError.h"
#import "SLExtensions.h"


@implementation SLGetDetailsByHashResponse

@synthesize imdbInfo;

- (id)init {
	if (self = [super init]) {
		currentXmlString = [[NSMutableString alloc] init];
		error = nil;
		
		imdbInfo = [[NSMutableDictionary alloc] init];
		resultString = [[NSMutableString alloc] init];
		parsingImdbInfo = NO;
	}
	
	return self;
}

- (void)dealloc {
	[currentXmlString release];
	[imdbInfo release];
	[resultString release];
	
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
	[imdbInfo removeAllObjects];
	[resultString setString:@""];
	parsingImdbInfo = NO;
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
    
    if ([elementName isEqualToString:@"imdbInfo"]) {
        parsingImdbInfo = YES;
        return;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//order is important!!!
	
    if ([elementName isEqualToString:@"imdbInfo"]) {
        parsingImdbInfo = NO;
		return;
    }
	
	if (parsingImdbInfo) {
		[imdbInfo setObject:[currentXmlString string] forKey:elementName];
		return;
	}
	
    if ([elementName isEqualToString:@"GetDetailsByHashResult"]) {
		[resultString setString:currentXmlString];
		return;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentXmlString appendString:string];
}

@end
