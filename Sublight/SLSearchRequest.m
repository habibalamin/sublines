//
//  Created by Hemant Jangid on 05/09/10 for Sublines.
//

#import "SLSearchRequest.h"
#import "SLExtensions.h"


@implementation SLSearchRequest

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
		NSString* placeHolderPath = [mainBundle pathForResource:@"SearchSubtitles" ofType:@"xml"];
		placeHolder = [[NSString alloc] initWithContentsOfFile:placeHolderPath];
	}
	
	DLog (@"Placeholder: %@", placeHolder);
	
	NSMutableString* request = [[NSMutableString alloc] initWithString:placeHolder];
	[request replaceOccurrencesOfString:@"[session]" withString:session];
	[request replaceOccurrencesOfString:@"[sublightHash]" withString:sublightHash];

	//in case we need to more search parameters, we can modify below code
	[request replaceOccurrencesOfString:@"[subtitleLanguages]" withString:@"<SubtitleLanguage>English</SubtitleLanguage>"];
	
	NSData* requestData = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];
	
	[requestData autorelease];
	[request release];
	
	return requestData;
}

@end
