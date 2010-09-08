//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import "SLSublightClient.h"
#import "SLSublightDelegate.h"
#import "SLExtensions.h"

#define CLIENT_ID @"Sublines"
#define API_KEY @"10288723-B094-428F-B329-DA970611AD9F"
#define WS_URL @"http://www.sublight.si/API/WS/Sublight.asmx"
#define WS_ACTION_LOGIN @"http://www.sublight.si/LogInAnonymous4"
#define WS_ACTION_GET_DETAILS_BY_HASH @"http://www.sublight.si/GetDetailsByHash"
#define WS_ACTION_SEARCH_SUBTITLES @"http://www.sublight.si/SearchSubtitles3"
#define WS_ACTION_GET_DOWNLOAD_TICKET @"http://www.sublight.si/GetDownloadTicket2"
#define WS_ACTION_DOWNLOAD_BY_ID @"http://www.sublight.si/DownloadByID4"
#define WS_ACTION_LOGOUT @"http://www.sublight.si/LogOut"

@interface SLSublightClient ()

- (void)connection:(NSURLConnection*)connection finishedWithError:(NSError*)error;

@end


@implementation SLSublightClient

- (id)initWithDelegate:(id<SLSublightDelegate>)responseDelegate {
	if (self = [super init]) {
		currentAction = SublightActionNone;
		delegate = responseDelegate;
		urlData = [[NSMutableData alloc] init];
		
		requestLoginAnonymous = [[SLLoginAnonymousRequest alloc] init];
		requestGetDetailsByHash = [[SLGetDetailsByHashRequest alloc] init];
		requestSearch = [[SLSearchRequest alloc] init];
		requestGetDownloadTicket = [[SLGetDownloadTicketRequest alloc] init];
		requestDownloadById = [[SLDownloadByIdRequest alloc] init];
		requestLogout = [[SLLogoutRequest alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[urlData release];
	
	[requestLoginAnonymous release];
	[requestGetDetailsByHash release];
	[requestSearch release];
	[requestGetDownloadTicket release];
	[requestDownloadById release];
	[requestLogout release];
	
	[super dealloc];
}

- (void)requestSoapAction:(NSString*)soapAction ofType:(SublightAction)actionType withData:(NSData*)soapData {
	DLog(@"Requesting data: %@", [soapData asciiString]);

	assert (currentAction == SublightActionNone);
	
	currentAction = actionType;

	NSURL *url = [NSURL URLWithString:WS_URL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *contentLength = [NSString stringWithFormat:@"%d", [soapData length]];
	[urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
	[urlRequest addValue:contentLength forHTTPHeaderField:@"Content-Length"];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:soapData];
	
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
	
	SublightAction finishedAction = currentAction;
	currentAction = SublightActionNone;
	
	switch (finishedAction) {
		case SublightActionLoginAnonymous: {
			SLLoginAnonymousResponse* response = nil;
			if (error == nil) {
				response = [[SLLoginAnonymousResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate loginAnonymousDoneWithClient:self error:error response:response];
			break;
		}
			
		case SublightActionGetDetailsByHash: {
			SLGetDetailsByHashResponse* response = nil;
			if (error == nil) {
				response = [[SLGetDetailsByHashResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate getDetailsByHashDoneWithClient:self error:error response:response];
			break;
		}
			
		case SublightActionSearch: {
			SLSearchResponse* response = nil;
			if (error == nil) {
				response = [[SLSearchResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate searchSubtitlesDoneWithClient:self error:error response:response];
			break;
		}
			
		case SublightActionGetDownloadTicket: {
			SLGetDownloadTicketResponse* response = nil;
			if (error == nil) {
				response = [[SLGetDownloadTicketResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate getDownloadTicketDoneWithClient:self error:error response:response];
			break;
		}
			
		case SublightActionDownloadById: {
			SLDownloadByIdResponse* response = nil;
			if (error == nil) {
				response = [[SLDownloadByIdResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate downloadByIdDoneWithClient:self error:error response:response];
			break;
		}

		case SublightActionLogout: {
			SLLogoutResponse *response = nil;
			if (error == nil) {
				response = [[SLLogoutResponse alloc] init];
				error = [response parse:urlData];
				[response autorelease];
			}
			[delegate logoutDoneWithClient:self error:error response:response];
			break;
		}
	}
}

#pragma mark Service Methods

- (void)loginAnonymous {
	NSData* requestData = [requestLoginAnonymous requestWithClientId:CLIENT_ID apiKey:API_KEY args:nil];
	[self requestSoapAction:WS_ACTION_LOGIN ofType:SublightActionLoginAnonymous withData:requestData];
}

- (void)getDetailsByHash:(NSString*)hash session:(NSString*)session {
	NSData* requestData = [requestGetDetailsByHash requestWithSession:session sublightHash:hash];
	[self requestSoapAction:WS_ACTION_GET_DETAILS_BY_HASH ofType:SublightActionGetDetailsByHash withData:requestData];
}

- (void)searchSubtitlesByHash:(NSString*)hash session:(NSString*)session {
	NSData* requestData = [requestSearch requestWithSession:session sublightHash:hash];
	[self requestSoapAction:WS_ACTION_SEARCH_SUBTITLES ofType:SublightActionSearch withData:requestData];
}

- (void)getDownloadTicketOfId:(NSString*)subtitleId session:(NSString*)session {
	NSData* requestData = [requestGetDownloadTicket requestWithSession:session subtitleId:subtitleId];
	[self requestSoapAction:WS_ACTION_GET_DOWNLOAD_TICKET ofType:SublightActionGetDownloadTicket withData:requestData];
}

- (void)downloadById:(NSString*)subtitleId ticket:(NSString*)ticket session:(NSString*)session {
	NSData* requestData = [requestDownloadById requestWithSession:session subtitleId:subtitleId ticket:ticket];
	[self requestSoapAction:WS_ACTION_DOWNLOAD_BY_ID ofType:SublightActionDownloadById withData:requestData];
}

- (void)logoutSession:(NSString*)session {
	NSData* requestData = [requestLogout requestWithSession:session];
	[self requestSoapAction:WS_ACTION_LOGOUT ofType:SublightActionLogout withData:requestData];	
}

@end
