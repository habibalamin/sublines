//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLTmdbMovieInfo : NSObject {
	NSString *tmdbId;
	NSString *imdbId;
	NSString *movieName;
	NSString *originalName;
	NSString *alternateName;
	NSString *overview;
	NSDate *released;
	BOOL isAdult;
	double rating;
	NSString *certification;
	int popularity;
	int runtime;
	NSString *videoType;
	NSString *movieLanguage;
	BOOL translated;
	int votes;
	NSString *tmdbUrl;
	NSDate *lastModified;
	int recordVersion;
}

- (id)init;
- (void)dealloc;
- (void)clear;

@property (nonatomic, assign) NSString *tmdbId;
@property (nonatomic, retain) NSString *imdbId;
@property (nonatomic, retain) NSString *movieName;
@property (nonatomic, retain) NSString *originalName;
@property (nonatomic, retain) NSString *alternateName;
@property (nonatomic, retain) NSString *overview;
@property (nonatomic, retain) NSDate *released;
@property (nonatomic, assign) BOOL isAdult;
@property (nonatomic, assign) double rating;
@property (nonatomic, retain) NSString *certification;
@property (nonatomic, assign) int popularity;
@property (nonatomic, assign) int runtime;
@property (nonatomic, retain) NSString *videoType;
@property (nonatomic, retain) NSString *movieLanguage;
@property (nonatomic, assign) BOOL translated;
@property (nonatomic, assign) int votes;
@property (nonatomic, retain) NSString *tmdbUrl;
@property (nonatomic, retain) NSDate *lastModified;
@property (nonatomic, assign) int recordVersion;

@end
