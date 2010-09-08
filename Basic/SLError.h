//
//  Created by Hemant Jangid on 02/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>

#define APP_ERROR_DOMAIN @"com.sublines.ErrorDomain"

typedef	enum {
	SLSuccess = 0,
    SLFailed = 1,
	SLFileDoesNotExist = 2,
	SLFailedToLoadLibrary = 3,
	SLInvalidFile = 4,
	SLInvalidOutputFromLibrary = 5,
	SLFileTooSmall = 6,
	SLInvalidApiKey = 7,

	//Dragging
	SLInvalidDragItem = 8,
	SLTooManyFilesDragged = 9,
	
	SLMediaFileNotRecognised = 10,
	SLFileAlreadyOpened = 11,
	
	SLUnableToUnzip = 12,
	SLNoSubtitlesReceived = 13
} SLResult;

@interface SLError : NSError {

}

+ (id)errorWithCode:(SLResult)code;
- (id)initWithCode:(SLResult)code;

- (NSString *)localizedDescription;
- (NSString *)localizedFailureReason;
- (NSString *)localizedRecoverySuggestion;

@end
