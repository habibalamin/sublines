//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import "SLSearchResponse.h"
#import "SLExtensions.h"
#import "SLError.h"

@implementation SLSearchResponse

@synthesize subtitleList;

- (id)init {
    if (self = [super init]) {
        currentXmlString = [[NSMutableString alloc] init];
        subtitleDetails = [[NSMutableDictionary alloc] init];
        subtitleList = [[NSMutableArray alloc] init];
		resultString = [[NSMutableString alloc] init];
        parsingSubtitle = NO;
		error = nil;
    }
    
    return self;
}

- (void)dealloc {
    [currentXmlString release];
    [subtitleDetails release];
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
	[subtitleDetails removeAllObjects];
	[subtitleList removeAllObjects];
	[resultString setString:@""];
	parsingSubtitle = NO;
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
    
    if ([elementName isEqualToString:@"Subtitle"]) {
        parsingSubtitle = YES;
        return;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//order is important!!!
	
    if ([elementName isEqualToString:@"Subtitle"]) {
        parsingSubtitle = NO;
		DLog (@"Adding dictionary with count: %d", [subtitleDetails count]);
		NSDictionary *subtitle = [[NSDictionary alloc] initWithDictionary:subtitleDetails];
        [subtitleList addObject:subtitle];
        [subtitle release];
        [subtitleDetails removeAllObjects];
		return;
    }

	if (parsingSubtitle) {
		[subtitleDetails setObject:[currentXmlString string] forKey:elementName];
		return;
	}
	
    if ([elementName isEqualToString:@"SearchSubtitles3Result"]) {
		[resultString setString:[currentXmlString string]];
		return;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentXmlString appendString:string];
}

@end
