//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	TmdbImageTypeUnknown = 0,
	TmdbImageTypeOriginal = 1,
	TmdbImageTypeMid = 2,
	TmdbImageTypeCover = 3,
	TmdbImageTypeThumb = 4
}TmdbImageType;

@interface SLTmdbImage : NSObject {
	int height;
	int width;
	TmdbImageType imageType;
	NSString *tmdbUrl;
}

- (id)init;
- (void)dealloc;
- (void)clear;

@property (nonatomic, assign) int height;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) TmdbImageType imageType;
@property (nonatomic, retain) NSString *tmdbUrl;

@end
