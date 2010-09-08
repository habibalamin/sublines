//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>

@interface NSMutableString (Helper)

-(NSString*)string;
-(NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;

@end

@interface NSData (Helper)

-(NSString*)asciiString;
-(NSString*)utf8String;
-(NSString*)unicodeString;

@end