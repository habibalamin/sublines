//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "SLImdbLookupResponse.h";

@class SLTmdbClient;

@protocol SLTmdbDelegate

- (void)imdbLookupDoneWithClient:(SLTmdbClient*)client error:(NSError*)error response:(SLImdbLookupResponse*)response;
- (void)imageLoadingDoneWithClient:(SLTmdbClient*)client error:(NSError*)error response:(NSData*)response;

@end

