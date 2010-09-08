//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import "SLMoviePoster.h"


@implementation SLMoviePoster

@synthesize imageUrl;
@synthesize imageId;
@synthesize imageData;
@synthesize imageUrlOrig;

- (id)init {
	if (self = [super init]) {
		imageUrl = nil;
		imageId = nil;
		imageData = nil;
		imageUrlOrig = nil;
	}
	
	return self;
}

- (void)dealloc {
	self.imageUrl = nil;
	self.imageId = nil;
	self.imageData = nil;
	self.imageUrlOrig = nil;

	[super dealloc];
}

@end
