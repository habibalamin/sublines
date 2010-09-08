//
//  Created by Hemant Jangid on 02/09/10 for Sublines.
//

#import "SLError.h"


@implementation SLError

+ (id)errorWithCode:(SLResult)code {
	SLError *err = [[SLError alloc] initWithCode:code];
	[err autorelease];
	return err;
}

- (id)initWithCode:(SLResult)code {
	if (self = [super initWithDomain:APP_ERROR_DOMAIN code:code userInfo:nil]) {
		//other initialization
	}
	
	return self;
}

- (NSString *)localizedDescription {
	if (![[self domain] isEqualToString:APP_ERROR_DOMAIN])
		return [super localizedDescription];
	
	switch ([self code]) {
		case SLFailed: return @"Operation failed due to an internal error.";
		case SLFileDoesNotExist: return @"File doesn't exist.";
		case SLFailedToLoadLibrary: return @"Failed to load internal library.";
		case SLInvalidFile: return @"This file is not a valid media file.";
		case SLInvalidOutputFromLibrary: return @"An invalid output is received from internal library.";
		case SLFileTooSmall: return @"This file is too small to be valid media file.";
		case SLInvalidApiKey: return @"API key used by application is invalid. This key may have been revoked.";			
		case SLInvalidDragItem: return @"Unable to determine the file to analyse.";
		case SLTooManyFilesDragged: return @"Unable to work on multiple files.";
		case SLMediaFileNotRecognised: return @"Sorry, there is no record of this media file.";
		case SLFileAlreadyOpened: return @"This file is already open.";
		case SLUnableToUnzip: return @"Unzip operation failed.";
		case SLNoSubtitlesReceived: return @"No subtitles found in the package.";
			
		default:
			return [super localizedDescription];
	}
}

- (NSString *)localizedFailureReason {
	if (![[self domain] isEqualToString:APP_ERROR_DOMAIN])
		return [super localizedFailureReason];
	
	switch ([self code]) {
			
		default:
			return [super localizedDescription]; //Yeah..I am being lazy. Just return the description.
	}	
}

- (NSString *)localizedRecoverySuggestion {
	if (![[self domain] isEqualToString:APP_ERROR_DOMAIN])
		return [super localizedRecoverySuggestion];
	
	switch ([self code]) {
		case SLFailed: return @"Curse the developer.";			
		case SLFileDoesNotExist: return @"Try again with a valid media file.";
		case SLFailedToLoadLibrary: return @"Try downloading the updated version of application from internet.";
		case SLInvalidFile: return @"Try again with a valid media file.";
		case SLInvalidOutputFromLibrary: return @"Try downloading the updated version of application from internet.";
		case SLFileTooSmall: return @"Try again with a bigger media file.";
		case SLInvalidApiKey: return @"Try downloading the updated version of application from internet.";
		case SLInvalidDragItem: return @"Try again with a valid media file.";
		case SLTooManyFilesDragged: return @"If you have multiple files (like multiple CDs, episodes), just use the first file.";
		case SLMediaFileNotRecognised: return @"If you are sure this is a valid media file, try searching the subtitles on internet directly.";
		case SLFileAlreadyOpened: return @"Try a different file.";
		case SLUnableToUnzip: return @"Try a different subtitle.";
		case SLNoSubtitlesReceived: return @"Try a different subtitle.";

		default:
			return [super localizedRecoverySuggestion];
	}	
}

@end
