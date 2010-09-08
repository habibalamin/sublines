//
//  Created by Hemant Jangid on 05/09/10 for Sublines.
//

#import "SLGetDownloadTicketRequest.h"
#import "SLExtensions.h"
#import "SLError.h"

@implementation SLGetDownloadTicketRequest

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

- (NSData*)requestWithSession:(NSString*)session subtitleId:(NSString*)subtitleId {
	if (!placeHolder) { //load the place holder if not done already
		NSBundle* mainBundle = [NSBundle mainBundle];
		NSString* placeHolderPath = [mainBundle pathForResource:@"GetDownloadTicket" ofType:@"xml"];
		placeHolder = [[NSString alloc] initWithContentsOfFile:placeHolderPath];
	}
	
	DLog (@"Placeholder: %@", placeHolder);
	
	NSMutableString* request = [[NSMutableString alloc] initWithString:placeHolder];
	[request replaceOccurrencesOfString:@"[session]" withString:session];
	[request replaceOccurrencesOfString:@"[subtitleId]" withString:subtitleId];
		
	NSData* requestData = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];
	
	[requestData autorelease];
	[request release];
	
	return requestData;
}

@end
