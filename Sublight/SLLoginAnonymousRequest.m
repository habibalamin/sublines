//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import "SLLoginAnonymousRequest.h"
#import "SLExtensions.h"

@implementation SLLoginAnonymousRequest

- (id)init {
	if (self = [super init]) {
		placeHolder = nil; //we will rely on lazy initialization to minimize the app start-up time
	}
	
	return self;
}

- (void)dealloc {
	if (placeHolder)
		[placeHolder release];
	
	[super dealloc];
}

- (NSData*)requestWithClientId: (NSString*)clientId apiKey:(NSString*)apiKey args:(NSArray*)args {
	if (!placeHolder) { //load the place holder if not done already
		NSBundle* mainBundle = [NSBundle mainBundle];
		NSString* placeHolderPath = [mainBundle pathForResource:@"LoginAnonymous" ofType:@"xml"];
		placeHolder = [[NSString alloc] initWithContentsOfFile:placeHolderPath];
	}
	
	NSMutableString* request = [[NSMutableString alloc] initWithString:placeHolder];
	[request replaceOccurrencesOfString:@"[clientId]" withString:clientId];
	[request replaceOccurrencesOfString:@"[apiKey]" withString:apiKey];
	
	NSMutableString* argsXml = [[NSMutableString alloc] init];
	for (int i=0; i < [args count]; i++)
		[argsXml appendFormat:@"<string>%@</string>", [args objectAtIndex:i]];
	[request replaceOccurrencesOfString:@"[args]" withString:[argsXml string]];

	NSData* requestData = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];

	[argsXml release];
	[requestData autorelease];
	[request release];
	
	return requestData;
}

@end
