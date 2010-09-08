//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import "SLTmdbClient.h"
#import "SLTmdbDelegate.h"
#import "SLExtensions.h"

#define API_KEY @"0f80c5de13dea18753f6f7ae38db0dfb"
#define WS_ACTION_IMDB_LOOKUP @"http://api.themoviedb.org/2.1/Movie.imdbLookup/[language]/json/[apiKey]/[imdbId]"

@interface SLTmdbClient ()

- (void)requestAction:(NSString*)soapAction ofType:(TmdbAction)actionType;
- (void)connection:(NSURLConnection*)connection finishedWithError:(NSError*)error;

@end


@implementation SLTmdbClient

- (id)initWithDelegate:(id<SLTmdbDelegate>)responseDelegate {
	if (self = [super init]) {
		currentAction = TmdbActionNone;
		delegate = responseDelegate;
		urlData = [[NSMutableData alloc] init];
		request = [[NSMutableString alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[urlData release];
	[request release];
	
	[super dealloc];
}

- (void)requestAction:(NSString*)soapAction ofType:(TmdbAction)actionType {
	DLog(@"Requesting action: %@", soapAction);
	
	assert (currentAction == TmdbActionNone);
	
	currentAction = actionType;
	
	NSURL *url = [NSURL URLWithString:soapAction];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];	
	urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [urlData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self connection:connection finishedWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self connection:connection finishedWithError:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [urlData appendData:data];
}

- (void)connection:(NSURLConnection*)connection finishedWithError:(NSError*)error {
	DLog(@"Received data: %@", [urlData asciiString]);
	
	[urlConnection release];
	TmdbAction finishedAction = currentAction;
	currentAction = TmdbActionNone;
	
	switch (finishedAction) {
		case TmdbActionImdbLookup: {
			SLImdbLookupResponse* response = nil;
			if (error == nil) {
				response = [[SLImdbLookupResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate imdbLookupDoneWithClient:self error:error response:response];
			break;
		}
			
		case TmdbActionLoadImage: {
			[delegate imageLoadingDoneWithClient:self error:error response:[NSData dataWithData:urlData]];
			break;
		}
	}
}

#pragma mark Service Methods

- (void)lookupImdbId:(NSString*)imdbId {
	[request setString:WS_ACTION_IMDB_LOOKUP];
	[request replaceOccurrencesOfString:@"[language]" withString:@"en"];
	[request replaceOccurrencesOfString:@"[apiKey]" withString:API_KEY];
	[request replaceOccurrencesOfString:@"[imdbId]" withString:imdbId];
	[self requestAction:[request string] ofType:TmdbActionImdbLookup];
}

- (void)loadImage:(NSString*)imgUrl {
	[self requestAction:imgUrl ofType:TmdbActionLoadImage];
}

@end
