#import <Foundation/Foundation.h>

@class DFPost;


@interface DFTimeline : NSObject

@property(nonatomic, readonly) long newestPostID;
@property(nonatomic, readonly) long oldestPostID;

@property (nonatomic, readonly) long count;

- (DFPost *)postAtIndex:(NSUInteger)objectIndex;

- (void)addPost:(DFPost *)aPost;

@end