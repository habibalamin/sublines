//
//  Created by Hemant Jangid on 01/09/10 for Sublines.
//

#import "SublinesAppDelegate.h"
#import "SLSublightClient.h"
#import "SLError.h"
#import "SLMediaInfo.h"
#import "SLFileInfo.h"
#import "SLMoviePoster.h"
#import "NSData+Base64.h"
#import "SLExtensions.h"
#import "SLUnzip.h"

#define TABLE_SUBTITLES 0

@interface SublinesAppDelegate ()

- (void)loginAnonymous;
- (void)getDetailsByHash;
- (void)searchByHash;
- (void)getDownloadTicket;
- (void)download;
- (void)logout;

- (void)imdbLookupForId:(NSString*)imdbId;
- (void)loadImage:(NSString*)imgUrl;
- (void)openMediaFile:(NSString*)file;
- (void)loadNextPoster;
- (void)loadPreviousPoster;
- (void)updatePosterButtons;
- (void)updatePoster;
- (void)clearInfo;

- (void)updateActivityDescription:(NSString*)description;
- (NSError*)calculateSublightHash:(NSString*)targetFile;
- (void)hideSearchResults:(BOOL)hide animate:(BOOL)animate;
- (int)calcSubtitleRankIsLinked:(BOOL)linked downloads:(int)downloads rating:(int)rating votes:(int)votes;

- (id)tableValueSubtitlesForRow:(int)rowIndex Column:(int)colIndex;
- (NSString*)prettyTimeIntervalStringFromMinutes:(int)totalMins;

@end


@implementation SublinesAppDelegate

@synthesize window;
@synthesize windowAbout;
@synthesize activityIndicator;
@synthesize labelActivity;
@synthesize labelMovieTitle;
@synthesize buttonMoviePoster;
@synthesize buttonImageNext;
@synthesize buttonImagePrev;
@synthesize textViewMovieOverview;
@synthesize buttonImFeelingLucky;
@synthesize buttonSearchSubtitles;
@synthesize tableSubtitles;
@synthesize levelRating;
@synthesize labelReleased;
@synthesize labelCertification;
@synthesize labelAdult;
@synthesize labelLength;

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
	[self openMediaFile:filename];
	return true;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	DLog(@"Application will finished loading.");
	tableSubtitlesHeight = [tableSubtitles frame].size.height;
	[self hideSearchResults:YES animate:NO];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	DLog(@"Application finished loading.");
	
	working = NO;
	
	[self.window setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[self.window setContentBorderThickness:28 forEdge: NSMinYEdge];
	[self.window setDelegate:self];
	[self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[self.window setContentMinSize:NSMakeSize(675, 420)];
	[self.window makeFirstResponder:buttonImFeelingLucky];
	[self.tableSubtitles setDelegate:self];
	[self.tableSubtitles setDataSource:self];
	[self.tableSubtitles setDoubleAction: @selector(tableSubtitlesDoubleClicked:)];
	[self.tableSubtitles setTarget: self];
	
	targetFile = [[NSMutableString alloc] init];
	session = [[NSMutableString alloc] init];
	sublightHash = [[NSMutableString alloc] init];
	ticket = [[NSMutableString alloc] init];
	subtitleId = [[NSMutableString alloc] init];
	clientSublight = [[SLSublightClient alloc] initWithDelegate:self];
	clientTmdb = [[SLTmdbClient alloc] initWithDelegate:self];
	posterImages = [[NSMutableArray alloc] init];	
	subtitles = [[NSMutableArray alloc] init];
	
	NSString* imageName = [[NSBundle mainBundle] pathForResource:@"ImageUnknown" ofType:@"png"];
	imageUnknown = [[NSImage alloc] initWithContentsOfFile:imageName];
	
	[self clearInfo];
	[self loginAnonymous];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	DLog (@"Application will terminate.");
	
	[targetFile release];
	[session release];
	[sublightHash release];
	[ticket release];
	[subtitleId release];
	[clientSublight release];
	[clientTmdb release];
	[posterImages release];
	[imageUnknown release];
	
	[subtitles release];
	
	[self.window unregisterDraggedTypes];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}

- (BOOL)windowShouldClose:(id)sender {
	if ([session length] != 0) {
		[self logout];
		return NO;
	}
	
	return YES;
}

- (void)updateActivityDescription:(NSString*)description {
	if ((description == nil) || ([description length] == 0)) {
		[activityIndicator setHidden:YES];
		[activityIndicator stopAnimation:self];
		[labelActivity setHidden:YES];
		[labelActivity setStringValue:@""];
	}
	else {
		[activityIndicator setHidden:NO];
		[activityIndicator startAnimation:self];
		[labelActivity setHidden:NO];
		[labelActivity setStringValue:description];		
	}
}

- (void)showError:(NSError*)error {
	NSAlert *alert = [NSAlert alertWithError:error];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
}

- (IBAction)buttonPressedImageNext:(id)sender {
	[self loadNextPoster];
}

- (IBAction)buttonPressedImagePrev:(id)sender {
	[self loadPreviousPoster];
}

- (IBAction)buttonPressedImage:(id)sender {
	if ((currentIndex >= 0) && (currentIndex < [posterImages count])) {
		SLMoviePoster *mp = [posterImages objectAtIndex:currentIndex];
		
		if (mp.imageUrlOrig != nil) {
			NSURL* url = [NSURL URLWithString:mp.imageUrlOrig];
			[[NSWorkspace sharedWorkspace] openURL:url];
		}
	}
}

- (IBAction)buttonPressedSearchSubtitles:(id)sender {
	userIsFeelingLucky = NO;
	[self searchByHash];
}

- (IBAction)buttonPressedImFeelingLucky:(id)sender {
	userIsFeelingLucky = YES;
	[self searchByHash];
}

- (IBAction)menuFileOpen:(id)sender {
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg beginSheetModalForWindow:self.window
					completionHandler:^(NSInteger result) {
						if (result == NSOKButton) {
							if ([[openDlg filenames] count] > 1) {
								NSError *error = [SLError errorWithCode:SLTooManyFilesDragged];
								[self showError:error];
								return;
							}
							[self openMediaFile:[openDlg filename]];
						}
					}];
}

- (IBAction)showAbout:(id)sender {
    [NSApp beginSheet:windowAbout
       modalForWindow:window
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
}

- (IBAction)endAbout:(id)sender {
	// Return to normal event handling
	[NSApp endSheet:windowAbout];
	
	// Hide the sheet
	[windowAbout orderOut:sender];	
}

- (IBAction)openUrl:(id)sender {
	int tag = [sender tag];
	NSURL *url = nil;
	switch (tag) {
		case 0:
			url = [NSURL URLWithString:@"http://code.google.com/p/sublines/"];
			[[NSWorkspace sharedWorkspace] openURL:url];
			break;
		case 1:
			url = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=sublines%2eteam%40gmail%2ecom&lc=US&item_name=Sublines&no_note=0&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHostedGuest"];
			[[NSWorkspace sharedWorkspace] openURL:url];
			[self endAbout:self];
			break;
		case 2:
			url = [NSURL URLWithString:@"http://www.sublight.si/"];
			[[NSWorkspace sharedWorkspace] openURL:url];
			break;
		case 3:
			url = [NSURL URLWithString:@"http://www.themoviedb.org/"];
			[[NSWorkspace sharedWorkspace] openURL:url];
			break;
	}
}

#pragma mark Table handlers

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	switch ([aTableView tag]) {
		case TABLE_SUBTITLES: return [subtitles count];
		default: return 0;
	}
}

- (id)tableValueSubtitlesForRow:(int)rowIndex Column:(int)colIndex {
	if ((rowIndex < 0) || (rowIndex >= [subtitles count]))
		return @"Invalid row for subtitle table";
	
	NSDictionary *st = [subtitles objectAtIndex:rowIndex];
	
	switch (colIndex) {
		case 0: return [[st objectForKey:@"IsLinked"] isEqualToString:@"true"]? @"Yes": @"No";
		case 1: return [st objectForKey:@"MediaType"];
		case 2: return [st objectForKey:@"NumberOfDiscs"];
		case 3: return [st objectForKey:@"Language"];
		case 4: return [st objectForKey:@"Downloads"];
		case 5: return [st objectForKey:@"Rate"];
		case 6: return [st objectForKey:@"Votes"];
		default: return @"Invalid column for subtitle table";
	}
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	int colIndex = [[aTableColumn identifier] intValue];
	
	switch ([aTableView tag]) {
		case TABLE_SUBTITLES: return [self tableValueSubtitlesForRow:rowIndex Column:colIndex];
		default: return 0;
	}
}

- (void)tableSubtitlesDoubleClicked:(id)sender {
	int rowIndex = [tableSubtitles selectedRow];
	[subtitleId setString:[[subtitles objectAtIndex:rowIndex] objectForKey:@"SubtitleID"]];
	NSLog(@"Downloading subtitle. Row: %d, SubtitleId: %@", rowIndex, subtitleId);
	[self getDownloadTicket];
}

#pragma mark Operations

- (void)openMediaFile:(NSString*)file {
	//If it is the same file, don't do anything
	if ([targetFile isEqualToString:file]) {
		[self showError:[SLError errorWithCode:SLFileAlreadyOpened]];
		return;
	}
	
	[self clearInfo];
	
	[targetFile setString:file];
	NSError* error = [self calculateSublightHash:file];
	if (error != nil) {
		DLog(@"Error occurred while calculating sublight hash: %@", [error localizedDescription]);
		[self showError:error];
		return;
	}
	
	DLog (@"Sublight hash successfully calculated. File: %@, Hash: %@", file, sublightHash);
	
	[self getDetailsByHash];
}

- (void)clearInfo {
	[self hideSearchResults:YES animate:YES];
	[targetFile setString:@""];
	[movieInfo release];
	movieInfo = nil;
	[levelRating setDoubleValue:0];
	[labelReleased setStringValue:@""];
	[labelCertification setStringValue:@""];
	[labelAdult setStringValue:@""];
	[labelLength setStringValue:@""];
	[labelMovieTitle setStringValue:@"[Drag and drop a media file here]"];
	[textViewMovieOverview setStringValue:@""];
	currentIndex = -1;
	[buttonMoviePoster setImage:imageUnknown];
	[buttonMoviePoster setEnabled:NO];
	[buttonImagePrev setEnabled:NO];
	[buttonImageNext setEnabled:NO];
	[buttonImFeelingLucky setEnabled:NO];
	[buttonSearchSubtitles setEnabled:NO];
	[subtitles removeAllObjects];
	[tableSubtitles reloadData];
	[subtitleId setString:@""];
	[ticket setString:@""];
}

- (void)loadNextPoster {
	if ((currentIndex+1) >= [posterImages count])
		return;
	
	currentIndex++;
	
	[self updatePosterButtons];
	[self updatePoster];
}

- (void)loadPreviousPoster {
	if ((currentIndex-1) < 0)
		return;
	
	currentIndex--;
	
	[self updatePosterButtons];
	[self updatePoster];
}

- (void)updatePosterButtons {
	[buttonImagePrev setEnabled:(currentIndex >= 1)];
	[buttonImageNext setEnabled:(currentIndex < ([posterImages count] - 1))];	
}

- (void)updatePoster {
	SLMoviePoster *mp = [posterImages objectAtIndex:currentIndex];
	
	if (mp.imageData == nil) {
		[buttonImageNext setEnabled:NO];
		[buttonImagePrev setEnabled:NO];
		[self loadImage:mp.imageUrl];
	}
	else {
		[buttonMoviePoster setImage:mp.imageData];
	}
}

#pragma mark Drag Handler

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
	DLog(@"Dragging entered.");
	return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {	
	NSPasteboard* pb = [sender draggingPasteboard];
	NSArray* fileList = [pb propertyListForType:NSFilenamesPboardType];
	
	if ([fileList count] == 0) {
		NSError* error = [SLError errorWithCode:SLInvalidDragItem];
		[self showError:error];
		return NO;
	}

	if ([fileList count] > 1) {
		NSError* error = [SLError errorWithCode:SLTooManyFilesDragged];
		[self showError:error];
		return NO;
	}
	
	if (working)
		return NO;
	
	DLog(@"Perform drag operation on file: %@", [fileList objectAtIndex:0]);
	[self openMediaFile:[fileList objectAtIndex:0]];
	return YES;
}

- (void)draggingExited:(id < NSDraggingInfo >)sender {
	DLog(@"Dragging exited.");
}

#pragma mark Sublight Services

- (void)loginAnonymous {
	[self updateActivityDescription:@"Logging in..."];
	[clientSublight loginAnonymous];
}

- (void)getDetailsByHash {
	[self updateActivityDescription:@"Getting details..."];	
	[clientSublight getDetailsByHash:sublightHash session:session];
}

- (void)searchByHash {
	[self updateActivityDescription:@"Searching subtitles..."];	
	[clientSublight searchSubtitlesByHash:sublightHash session:session];
}

- (void)getDownloadTicket {
	[self updateActivityDescription:@"Getting download ticket..."];	
	[clientSublight getDownloadTicketOfId:subtitleId session:session];
}

- (void)download {
	[self updateActivityDescription:@"Downloading subtitles..."];
	[clientSublight downloadById:subtitleId ticket:ticket session:session];
}

- (void)logout {
	if (session == nil) {
		DLog(@"Skipping logout because current session is invalid.");
		return;
	}
	
	[self updateActivityDescription:@"Logging out..."];
	[clientSublight logoutSession:session];
}

- (void)loginAnonymousDoneWithClient:(SLSublightClient*)client 
							   error:(NSError*)error 
							response:(SLLoginAnonymousResponse*)response {
	[self updateActivityDescription: nil];

	if (error != nil) {
		[self showError:error];
		return;
	}

	[session setString:[response session]];
}

- (void)getDetailsByHashDoneWithClient:(SLSublightClient *)client 
								 error:(NSError *)error 
							  response:(SLGetDetailsByHashResponse *)response {
	
	[self updateActivityDescription: nil];
	
	if (error != nil) {
		[self showError:error];
		return;
	}
	
	NSDictionary *imdbInfo = [response imdbInfo];
	for (id d in [imdbInfo keyEnumerator])
		DLog (@"%@ : %@", d, [imdbInfo objectForKey:d]);
	
	NSString *imdbId = [imdbInfo objectForKey:@"Id"];
	
	if (imdbId == nil) {
		[self showError:[SLError errorWithCode:SLMediaFileNotRecognised]];
		return;
	}
	
	[self imdbLookupForId:imdbId];
}

- (void)searchSubtitlesDoneWithClient:(SLSublightClient *)client 
								error:(NSError *)error 
							 response:(SLSearchResponse *)response {
	
	[self updateActivityDescription: nil];

	if (error != nil) {
		[self showError:error];
		return;
	}
	
	[subtitles addObjectsFromArray:[response subtitleList]];

	for (id st in [subtitles objectEnumerator])
		DLog (@"%@", st);

	if (!userIsFeelingLucky) {
		[self hideSearchResults:NO animate:YES];
		[tableSubtitles reloadData];
	}
	else {
		//select a subtitle automatically and download it
		int highestRank = -1;
		int highestRankIndex = -1;
		
		for (int i=0; i < [subtitles count]; i++) {
			id st = [subtitles objectAtIndex:i];
			
			BOOL linked = [[st objectForKey:@"IsLinked"] isEqualToString:@"true"];
			int downloads = [[st objectForKey:@"Downloads"] intValue];
			int rating = (int) ([[st objectForKey:@"Rate"] doubleValue]);
			int votes = [[st objectForKey:@"Votes"] intValue];
			int itemRank = [self calcSubtitleRankIsLinked:linked downloads:downloads rating:rating votes:votes];
			
			if (itemRank > highestRank) {
				highestRank = itemRank;
				highestRankIndex = i;
			}
		}
		
		if (highestRankIndex < 0) {
			NSError* error = [SLError errorWithCode:SLNoSubtitleFoundAppropriate];
			[self showError:error];
			return;
		}
		
		[subtitleId setString:[[subtitles objectAtIndex:highestRankIndex] objectForKey:@"SubtitleID"]];
		[self getDownloadTicket];
	}
}

- (void)getDownloadTicketDoneWithClient:(SLSublightClient *)client 
								  error:(NSError *)error 
							   response:(SLGetDownloadTicketResponse *)response {
	
	[self updateActivityDescription: nil];
	
	if (error != nil) {
		[self showError:error];
		return;
	}
	
	[ticket setString:[response ticket]];
	
	NSString* activity = [NSString stringWithFormat:@"Download will start in %d seconds...", [response queue]];
	[self updateActivityDescription:activity];
	[NSTimer scheduledTimerWithTimeInterval: [response queue]
											 target: self
										   selector: @selector(delayedDownload:)
										   userInfo: nil
											repeats: NO];
}

- (void)delayedDownload:(NSTimer*)timer {
	[self download];
}

- (void)downloadByIdDoneWithClient:(SLSublightClient *)client 
							 error:(NSError *)error 
						  response:(SLDownloadByIdResponse *)response {
	
	[self updateActivityDescription: nil];
	
	if (error != nil) {
		[self showError:error];
		return;
	}
	
	NSData *subtitleContents = [NSData dataFromBase64String:response.subtitleData];
	
	SLUnzip *unzipper = [[SLUnzip alloc] init];
	NSError *subtitleError = [unzipper unzipSubtitles:subtitleContents ofExtension:@"srt" run:targetFile];
	[unzipper release];
	if (subtitleError != nil) {
		[self showError:subtitleError];
		return;
	}
}

- (void)logoutDoneWithClient:(SLSublightClient*)client 
					   error:(NSError*)error 
					response:(SLLogoutResponse*)response {
	
	[self updateActivityDescription: nil];
	[session setString:@""];

#ifdef DEBUG //don't bother about logout error in release build
	if (error != nil) {
		[self showError:error];
		return;
	}
#endif
	
	[self.window close];
}

#pragma mark TMDB Services

- (void)imdbLookupForId:(NSString*)imdbId  {
	[self updateActivityDescription:@"Getting movie details..."];	

	[clientTmdb lookupImdbId:imdbId];
}

- (void)imdbLookupDoneWithClient:(SLTmdbClient *)client 
						   error:(NSError *)error 
						response:(SLImdbLookupResponse *)response {
	
	[self updateActivityDescription:nil];
	
	if (error != nil) {
		[self showError:error];
		return;
	}

	movieInfo = [response.movieInfo retain];

	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];

	[labelMovieTitle setStringValue:movieInfo.movieName];
	[levelRating setDoubleValue:movieInfo.rating];
	[labelReleased setStringValue:[dateFormat stringFromDate:movieInfo.released]];
	[labelCertification setStringValue:movieInfo.certification];
	[labelAdult setStringValue:movieInfo.isAdult? @"Yes": @"No"];
	[labelLength setStringValue:[self prettyTimeIntervalStringFromMinutes:movieInfo.runtime]];
	[textViewMovieOverview setStringValue:movieInfo.overview];

	[buttonMoviePoster setEnabled:YES];
	[buttonImagePrev setEnabled:YES];
	[buttonImageNext setEnabled:YES];
	[buttonImFeelingLucky setEnabled:YES];
	[buttonSearchSubtitles setEnabled:YES];
	[self.window makeFirstResponder:buttonImFeelingLucky];
	
	[posterImages removeAllObjects];
	currentIndex = -1;
	
	for (id p in [response.posters objectEnumerator]) {
		NSString *imgSize = [p objectForKey:@"size"];
		NSString *imgId = [p objectForKey:@"id"];
		NSString *imgUrl = [p objectForKey:@"url"];
		
		if ([imgSize isEqualToString:@"cover"]) {
			SLMoviePoster *mp = [[SLMoviePoster alloc] init];
			[mp setImageId:imgId];
			[mp setImageUrl:imgUrl];
			[posterImages addObject:mp];
			[mp release];			
		}
	}
	
	for (id p in [response.posters objectEnumerator]) {
		NSString *imgSize = [p objectForKey:@"size"];
		NSString *imgId = [p objectForKey:@"id"];
		NSString *imgUrl = [p objectForKey:@"url"];
		
		if ([imgSize isEqualToString:@"original"]) {
			for (SLMoviePoster* pExisting in [posterImages objectEnumerator]) {
				if ([pExisting.imageId isEqualToString:imgId]) {
					pExisting.imageUrlOrig = imgUrl;
					break;
				}
			}
		}
	}

	if ([posterImages count] > 0) {
		currentIndex = 0;
		[self updatePoster];
	}
	else {
		currentIndex = -1;
		[buttonMoviePoster setImage:imageUnknown];
	}

	[self updatePosterButtons];
}

- (void)loadImage:(NSString*)imgUrl {
	[self updateActivityDescription:@"Getting poster..."];	
	
	[clientTmdb loadImage:imgUrl];
}

- (void)imageLoadingDoneWithClient:(SLTmdbClient *)client 
							 error:(NSError *)error 
						  response:(NSData *)response {
	
	[self updateActivityDescription:nil];

	if (error != nil) {
		[self showError:error];
		[buttonMoviePoster setImage:imageUnknown];
	}
	else {
		SLMoviePoster *mp = [posterImages objectAtIndex:currentIndex];
		NSImage *img = [[NSImage alloc] initWithData:response];
		[mp setImageData:img];
		[img release];
		[self updatePoster];
	}

	[self updatePosterButtons];
}

#pragma mark Worker functions

- (NSError*)calculateSublightHash:(NSString*)file {
	NSError* error;
	SLMediaInfo* mi = [[SLMediaInfo alloc] init];
	SLFileInfo* fi = [[SLFileInfo alloc] init];
	
	@try {	
		error = [fi analyse:file];
		if (error != nil)
			return error;		
		
		error = [mi analyse:file];
		if (error != nil)
			return error;

		Byte binaryHash[26];
		int i = 0;
		
		//Reserved
		binaryHash[i++] = 0x00;
		
		//Video duration
		binaryHash[i++] = ((mi.duration >> 8) & 0xFF);
		binaryHash[i++] = ((mi.duration >> 0) & 0xFF);
		
		//File size
		binaryHash[i++] = ((fi.size >> 40) & 0xFF);
		binaryHash[i++] = ((fi.size >> 32) & 0xFF);
		binaryHash[i++] = ((fi.size >> 24) & 0xFF);
		binaryHash[i++] = ((fi.size >> 16) & 0xFF);
		binaryHash[i++] = ((fi.size >> 8) & 0xFF);
		binaryHash[i++] = ((fi.size >> 0) & 0xFF);
		
		//MD5 hash
		memcpy(&(binaryHash[i]), [fi.md5Hash mutableBytes], [fi.md5Hash length]);
		i += [fi.md5Hash length];
		
		//Control byte
		Byte sum = 0x00;
		for (int j=0; j < 25; j++)
			sum += binaryHash[j];
		binaryHash[i] = sum;
		
		[sublightHash setString:@""];
		for (int j=0; j<26; j++)
			[sublightHash appendFormat:@"%02x", binaryHash[j]];
	}
	@finally {
		[mi release];
		[fi release];		
	}
	
	return nil;
}

- (NSString*)prettyTimeIntervalStringFromMinutes:(int)totalMins {
	if (totalMins < 60)
		return [NSString stringWithFormat:(totalMins == 1? @"%d minute": @"%d minutes"), totalMins];
	
	int mins = totalMins % 60;
	int hours = (int) (totalMins / 60);
	NSString *hoursString = [NSString stringWithFormat:(hours == 1? @"%d hour": @"%d hours"), hours];
	NSString *minssString = [NSString stringWithFormat:(mins == 1? @"%d minute": @"%d minutes"), mins];
	
	return [NSString stringWithFormat:@"%@, %@", hoursString, minssString];
}

- (void)hideSearchResults:(BOOL)hide animate:(BOOL)animate {
	if (hide == [tableSubtitles isHidden])
		return;
	
    NSRect frame = [self.window frame];
    
    CGFloat sizeChange = tableSubtitlesHeight + 20;
	
    switch (hide) {
        case NO:
            [tableSubtitles setHidden:NO];
            frame.size.height += sizeChange;
            frame.origin.y -= sizeChange;
            break;
			
        case YES:
            [tableSubtitles setHidden:YES];
            frame.size.height -= sizeChange;
            frame.origin.y += sizeChange;
            break;
			
        default:
            break;
    }
    [window setFrame:frame display:YES animate:animate];
}

- (int)calcSubtitleRankIsLinked:(BOOL)linked downloads:(int)downloads rating:(int)rating votes:(int)votes {
	return (linked? 500: 0) + downloads + (rating * 20);
}

@end
