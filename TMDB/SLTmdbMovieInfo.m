//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import "SLTmdbMovieInfo.h"


@implementation SLTmdbMovieInfo

@synthesize tmdbId;
@synthesize imdbId;
@synthesize movieName;
@synthesize originalName;
@synthesize alternateName;
@synthesize overview;
@synthesize released;
@synthesize isAdult;
@synthesize rating;
@synthesize certification;
@synthesize popularity;
@synthesize runtime;
@synthesize videoType;
@synthesize movieLanguage;
@synthesize translated;
@synthesize votes;
@synthesize tmdbUrl;
@synthesize lastModified;
@synthesize recordVersion;

- (id)init {
	if (self = [super init]) {
		tmdbId = nil;
		imdbId = nil;
		movieName = nil;
		originalName = nil;
		alternateName = nil;
		overview = nil;
		released = nil;
		isAdult = NO;
		rating = -1;
		certification = nil;
		popularity = -1;
		runtime = -1;
		videoType = nil;
		movieLanguage = nil;
		translated = NO;
		votes = -1;
		tmdbUrl = nil;
		lastModified = nil;
		recordVersion = -1;
	}
	
	return self;
}

- (void)dealloc {
	[self clear];
	
	[super dealloc];
}

- (void)clear {
	self.tmdbId = nil;
	self.imdbId = nil;
	self.movieName = nil;
	self.originalName = nil;
	self.alternateName = nil;
	self.overview = nil;
	self.released = nil;
	self.isAdult = NO;
	self.rating = -1;
	self.certification = nil;
	self.popularity = -1;
	self.runtime = -1;
	self.videoType = nil;
	self.movieLanguage = nil;
	self.translated = NO;
	self.votes = -1;
	self.tmdbUrl = nil;
	self.lastModified = nil;
	self.recordVersion = -1;
}

@end
