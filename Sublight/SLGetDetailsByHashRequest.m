//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import "SLGetDetailsByHashRequest.h"
#import "SLExtensions.h"

@implementation SLGetDetailsByHashRequest

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

- (NSData*)requestWithSession:(NSString*)session sublightHash:(NSString*)sublightHash {
	if (!placeHolder) { //load the place holder if not done already
		NSBundle* mainBundle = [NSBundle mainBundle];
		NSString* placeHolderPath = [mainBundle pathForResource:@"GetDetailsByHash" ofType:@"xml"];
		placeHolder = [[NSString alloc] initWithContentsOfFile:placeHolderPath];
	}
	
	NSMutableString* request = [[NSMutableString alloc] initWithString:placeHolder];
	[request replaceOccurrencesOfString:@"[session]" withString:session];
	[request replaceOccurrencesOfString:@"[sublightHash]" withString:sublightHash];

	NSData* requestData = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];
	
	[requestData autorelease];
	[request release];
	
	return requestData;
}

@end
