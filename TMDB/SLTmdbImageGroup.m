//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import "SLTmdbImageGroup.h"


@implementation SLTmdbImageGroup

@synthesize groupId;
@synthesize images;

- (id)init {
	if (self = [super init]) {
		groupId = [[NSMutableString alloc] init];
		images = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[groupId release];
	[images release];
	
	[super dealloc];
}

- (void)clear {
	[groupId setString:@""];
	[images removeAllObjects];
}

@end
