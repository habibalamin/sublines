//
//  Created by Hemant Jangid on 03/09/10 for Sublines.
//

#import "SLImdbLookupResponse.h"
#import "SLExtensions.h"
#import "SLError.h"
#import "JSON.h"

@implementation SLImdbLookupResponse

@synthesize movieInfo;
@synthesize info;
@synthesize genres;
@synthesize posters;
@synthesize backdrops;

- (id)init {
	if (self = [super init]) {
		parser = [[SBJsonParser alloc] init];
		
		movieInfo = [[SLTmdbMovieInfo alloc] init];
		info = [[NSMutableDictionary alloc] init];
		genres = [[NSMutableArray alloc] init];
		posters = [[NSMutableArray alloc] init];
		backdrops = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[parser release];
	
	[movieInfo release];
	[info release];
	[genres release];
	[posters release];
	[backdrops release];

	[super dealloc];
}

- (NSError*)parse:(NSData*)data {
	[movieInfo clear];
	[info removeAllObjects];
	[genres removeAllObjects];
	[posters removeAllObjects];
	[backdrops removeAllObjects];
	
	if ((data == nil) || ([data length] == 0))
		return [SLError errorWithCode:SLFailed]; 

	NSError *error = nil;
	NSArray *baseData = [parser objectWithString:[data utf8String] error:&error];
	if (error != nil)
		return error;

	if ([baseData count] != 1)
		return [SLError errorWithCode:SLFailed]; 
		
	NSDictionary *parsedData = [baseData objectAtIndex:0];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d" allowNaturalLanguage:NO];

	movieInfo.tmdbId = [parsedData objectForKey:@"id"];
	movieInfo.imdbId = [parsedData objectForKey:@"imdb_id"];
	movieInfo.movieName = [parsedData objectForKey:@"name"];
	movieInfo.originalName = [parsedData objectForKey:@"original_name"];
	movieInfo.alternateName = [parsedData objectForKey:@"alternative_name"];
	movieInfo.overview = [parsedData objectForKey:@"overview"];
	movieInfo.released = [dateFormatter dateFromString:[parsedData objectForKey:@"released"]];	
	movieInfo.isAdult = [[parsedData objectForKey:@"adult"] boolValue];
	movieInfo.rating = [[parsedData objectForKey:@"rating"] doubleValue];
	movieInfo.certification = [parsedData objectForKey:@"certification"];
	movieInfo.popularity = [[parsedData objectForKey:@"popularity"] intValue];
	movieInfo.runtime = [[parsedData objectForKey:@"runtime"] intValue];
	movieInfo.videoType = [parsedData objectForKey:@"movie_type"];
	movieInfo.movieLanguage = [parsedData objectForKey:@"language"];
	movieInfo.translated = [[parsedData objectForKey:@"translated"] boolValue];
	movieInfo.votes = [[parsedData objectForKey:@"votes"] intValue];
	movieInfo.tmdbUrl = [parsedData objectForKey:@"url"];
	movieInfo.lastModified = [dateFormatter dateFromString:[parsedData objectForKey:@"last_modified_at"]];
	movieInfo.recordVersion = [[parsedData objectForKey:@"version"] intValue];

	[genres addObjectsFromArray:[parsedData objectForKey:@"genres"]];
	
	for (id dict in [parsedData objectForKey:@"posters"])
		[posters addObject:[dict objectForKey:@"image"]];
		
	for (id dict in [parsedData objectForKey:@"backdrops"])
		[posters addObject:[dict objectForKey:@"image"]];
	
	[dateFormatter release];
	return nil;
}

@end
