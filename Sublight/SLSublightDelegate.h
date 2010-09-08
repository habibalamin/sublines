//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "SLError.h"
#import "SLLoginAnonymousResponse.h"
#import "SLGetDetailsByHashResponse.h"
#import "SLSearchResponse.h"
#import "SLGetDownloadTicketResponse.h"
#import "SLDownloadByIdResponse.h"
#import "SLLogoutResponse.h"

@class SLSublightClient;

@protocol SLSublightDelegate

- (void)loginAnonymousDoneWithClient:(SLSublightClient*)client error:(NSError*)error response:(SLLoginAnonymousResponse*)response;
- (void)getDetailsByHashDoneWithClient:(SLSublightClient*)client error:(NSError*)error response:(SLGetDetailsByHashResponse*)response;
- (void)searchSubtitlesDoneWithClient:(SLSublightClient*)client error:(NSError*)error response:(SLSearchResponse*)response;
- (void)getDownloadTicketDoneWithClient:(SLSublightClient*)client error:(NSError*)error response:(SLGetDownloadTicketResponse*)response;
- (void)downloadByIdDoneWithClient:(SLSublightClient*)client error:(NSError*)error response:(SLDownloadByIdResponse*)response;
- (void)logoutDoneWithClient:(SLSublightClient*)client error:(NSError*)error response:(SLLogoutResponse*)response;

@end
