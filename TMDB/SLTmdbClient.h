//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "SLTmdbDelegate.h"

typedef enum {
	TmdbActionNone = 0,
	TmdbActionImdbLookup = 1,
	TmdbActionLoadImage = 2
} TmdbAction;

@interface SLTmdbClient: NSObject {
	TmdbAction currentAction;
	NSMutableData *urlData;
	id<SLTmdbDelegate> delegate;
	NSURLConnection *urlConnection;
	NSMutableString *request;
}

- (id)initWithDelegate:(id<SLTmdbDelegate>)responseDelegate;
- (void)dealloc;

- (void)lookupImdbId:(NSString*)imdbId;
- (void)loadImage:(NSString*)imgUrl;

@end
