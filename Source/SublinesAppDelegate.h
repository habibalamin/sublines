//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>
#import "SLSublightClient.h"
#import "SLSublightDelegate.h"
#import "SLTmdbClient.h"
#import "SLTmdbDelegate.h"

@interface SublinesAppDelegate : NSObject <NSApplicationDelegate, SLSublightDelegate, SLTmdbDelegate, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    NSWindow *window;
	NSWindow *windowAbout;
	NSImage *imageUnknown;
	NSButton *buttonImageNext;
	NSButton *buttonImagePrev;
	NSProgressIndicator *activityIndicator;
	NSTextField *labelActivity;
	NSTextField *labelMovieTitle;
	NSButton *buttonMoviePoster;
	NSTextField *textViewMovieOverview;
	NSButton *buttonImFeelingLucky;
	NSButton *buttonSearchSubtitles;
	NSTableView *tableSubtitles;
	NSLevelIndicator *levelRating;
	NSTextField *labelReleased;
	NSTextField *labelCertification;
	NSTextField *labelAdult;
	NSTextField *labelLength;
	
	SLSublightClient *clientSublight;
	SLTmdbClient *clientTmdb;
	NSMutableString *targetFile;
	NSMutableString *session;
	NSMutableString *sublightHash;
	NSMutableArray *posterImages;
	NSMutableString *subtitleId;
	NSMutableString *ticket;
	int currentIndex;
	SLTmdbMovieInfo *movieInfo;
	NSMutableArray *subtitles;
	int tableSubtitlesHeight;
	BOOL userIsFeelingLucky;
	
	BOOL working;
}

- (IBAction)buttonPressedImageNext:(id)sender;
- (IBAction)buttonPressedImagePrev:(id)sender;
- (IBAction)buttonPressedImage:(id)sender;
- (IBAction)buttonPressedSearchSubtitles:(id)sender;
- (IBAction)buttonPressedImFeelingLucky:(id)sender;

- (IBAction)showAbout:(id)sender;
- (IBAction)endAbout:(id)sender;
- (IBAction)openUrl:(id)sender;

- (IBAction)menuFileOpen:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *windowAbout;
@property (assign) IBOutlet NSProgressIndicator *activityIndicator;
@property (assign) IBOutlet NSTextField *labelActivity;
@property (assign) IBOutlet NSTextField *labelMovieTitle;
@property (assign) IBOutlet NSButton *buttonMoviePoster;
@property (assign) IBOutlet NSButton *buttonImageNext;
@property (assign) IBOutlet NSButton *buttonImagePrev;
@property (assign) IBOutlet NSTextField *textViewMovieOverview;
@property (assign) IBOutlet NSButton *buttonImFeelingLucky;
@property (assign) IBOutlet NSButton *buttonSearchSubtitles;
@property (assign) IBOutlet NSTableView *tableSubtitles;
@property (assign) IBOutlet NSLevelIndicator *levelRating;
@property (assign) IBOutlet NSTextField *labelReleased;
@property (assign) IBOutlet NSTextField *labelCertification;
@property (assign) IBOutlet NSTextField *labelAdult;
@property (assign) IBOutlet NSTextField *labelLength;

@end
