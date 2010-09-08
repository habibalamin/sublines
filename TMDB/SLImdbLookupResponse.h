//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"
#import "SLTmdbMovieInfo.h"


@interface SLImdbLookupResponse : NSObject {
	SBJsonParser *parser;
	
	NSMutableDictionary *info;
	SLTmdbMovieInfo *movieInfo;
	NSMutableArray *genres;
	NSMutableArray *posters;
	NSMutableArray *backdrops;
}

- (id)init;
- (void)dealloc;

- (NSError*)parse:(NSData*)data;

@property (nonatomic, readonly) SLTmdbMovieInfo *movieInfo;
@property (nonatomic, readonly) NSDictionary *info;
@property (nonatomic, readonly) NSArray *genres;
@property (nonatomic, readonly) NSArray *posters;
@property (nonatomic, readonly) NSArray *backdrops;

@end
