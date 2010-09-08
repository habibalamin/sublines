//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import "SLTmdbImage.h"


@implementation SLTmdbImage

@synthesize height;
@synthesize width;
@synthesize imageType;
@synthesize tmdbUrl;

- (id)init {
	if (self = [super init]) {
		height = 0;
		width = 0;
		imageType = TmdbImageTypeUnknown;
		tmdbUrl = nil;
	}
	
	return self;
}

- (void)dealloc {
	[self clear];
	[super dealloc];
}

- (void)clear {
	self.height = 0;
	self.width = 0;
	self.imageType = TmdbImageTypeUnknown;
	self.tmdbUrl = nil;	
}


@end
