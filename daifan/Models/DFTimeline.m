#import "DFTimeline.h"
#import "DFPost.h"


@implementation DFTimeline {
    NSMutableArray *_posts;
}

- (id)init {
    self = [super init];
    if (self) {
        _posts = [[NSMutableArray alloc] init];

        _newestPostID = 0;
        _oldestPostID = LONG_MAX;
    }

    return self;
}

- (long)count {
    return _posts.count;
}

- (DFPost *)postAtIndex:(NSUInteger)objectIndex {
    if (objectIndex >= _posts.count) {
        return nil;
    }

    return [_posts objectAtIndex:objectIndex];
}

- (void)addPost:(DFPost *)aPost {
    [self updateIDRange:aPost];

    [_posts insertOrReplaceObjectSorted:aPost];
}

- (void)updateIDRange:(DFPost *)post {
    if (post.identity > _newestPostID) {
        _newestPostID = post.identity;
    }

    if (post.identity < _oldestPostID) {
        _oldestPostID = post.identity;
    }
}



@end