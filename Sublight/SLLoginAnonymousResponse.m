//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import "SLLoginAnonymousResponse.h"
#import "SLError.h"
#import "SLExtensions.h"

#define INVALID_SESSION @"00000000-0000-0000-0000-000000000000"

@implementation SLLoginAnonymousResponse

@synthesize session;
@synthesize settings;

- (id)init {
	if (self = [super init]) {
		currentXmlString = [[NSMutableString alloc] init];
		
		session = [[NSMutableString alloc] init];
		settings = [[NSMutableArray alloc] init];
		error = nil;
		parsingSettings = NO;
	}
	
	return self;
}

- (void)dealloc {
	[currentXmlString release];
	[session release];	
	[settings release];
	
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
	[session setString:@""];
	[settings removeAllObjects];
	error = [SLError errorWithCode:SLFailed];
	parsingSettings = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	error = [session isEqualToString:INVALID_SESSION]? [SLError errorWithCode:SLInvalidApiKey]: nil;
	[parser release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	error = parseError;
	[parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [currentXmlString setString:@""]; //clear the xml string
    
    if ([elementName isEqualToString:@"settings"]) {
        parsingSettings = YES;
        return;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//order is important!!!
	
    if ([elementName isEqualToString:@"settings"]) {
        parsingSettings = NO;
		return;
    }
	
	if (parsingSettings && [elementName isEqualToString:@"string"]) {
		[settings addObject:[currentXmlString string]];
		return;
	}
	
    if ([elementName isEqualToString:@"LogInAnonymous4Result"]) {
		[session setString:currentXmlString];
		return;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentXmlString appendString:string];
}


@end
