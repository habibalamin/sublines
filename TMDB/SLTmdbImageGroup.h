//
//  Created by Hemant Jangid on 04/09/10 for Sublines.
//

#import <Cocoa/Cocoa.h>


@interface SLTmdbImageGroup : NSObject {
	NSMutableString *groupId;
	NSMutableDictionary *images;
}

- (id)init;
- (void)dealloc;
- (void)clear;

@property (nonatomic, readonly) NSMutableString *groupId;
@property (nonatomic, readonly) NSMutableDictionary *images;

@end
