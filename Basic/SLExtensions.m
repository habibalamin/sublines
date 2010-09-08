//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import "SLExtensions.h"


@implementation NSMutableString (Helper)

- (NSString*) string {
	return [NSString stringWithFormat:@"%@", self];
}

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
	return [self replaceOccurrencesOfString: target 
								 withString: replacement 
									options: NSLiteralSearch 
									  range: NSMakeRange(0, [self length])];
}

@end

@implementation NSData (Helper)

- (NSString*)asciiString {
	NSString* str = [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
	[str autorelease];
	return str;
}

- (NSString*)utf8String {
	NSString* str = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
	[str autorelease];
	return str;	
}

-(NSString*)unicodeString {
	NSString* str = [[NSString alloc] initWithData:self encoding:NSUnicodeStringEncoding];
	[str autorelease];
	return str;	
}

@end