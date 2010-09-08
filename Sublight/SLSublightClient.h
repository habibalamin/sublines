//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "SLSublightDelegate.h"
#import "SLLoginAnonymousRequest.h"
#import "SLGetDetailsByHashRequest.h"
#import "SLSearchRequest.h"
#import "SLGetDownloadTicketRequest.h"
#import "SLDownloadByIdRequest.h"
#import "SLLogoutRequest.h"

typedef enum {
	SublightActionNone = 0,
	SublightActionLoginAnonymous = 1,
	SublightActionGetDetailsByHash = 2,
	SublightActionSearch = 3,
	SublightActionGetDownloadTicket = 4,
	SublightActionDownloadById = 5,
	SublightActionLogout = 6
} SublightAction;

@interface SLSublightClient: NSObject {
	SublightAction currentAction;
	NSMutableData *urlData;
	id<SLSublightDelegate> delegate;
	NSURLConnection *urlConnection;
	
	SLLoginAnonymousRequest *requestLoginAnonymous;
	SLGetDetailsByHashRequest *requestGetDetailsByHash;
	SLSearchRequest *requestSearch;
	SLGetDownloadTicketRequest *requestGetDownloadTicket;
	SLDownloadByIdRequest *requestDownloadById;
	SLLogoutRequest *requestLogout;
}

- (id)initWithDelegate:(id<SLSublightDelegate>)responseDelegate;
- (void)dealloc;

- (void)loginAnonymous;
- (void)getDetailsByHash:(NSString*)hash session:(NSString*)session;
- (void)searchSubtitlesByHash:(NSString*)hash session:(NSString*)session;
- (void)getDownloadTicketOfId:(NSString*)subtitleId session:(NSString*)session;
- (void)downloadById:(NSString*)subtitleId ticket:(NSString*)ticket session:(NSString*)session;
- (void)logoutSession:(NSString*)session;

@end
