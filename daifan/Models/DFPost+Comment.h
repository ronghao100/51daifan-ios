#import <Foundation/Foundation.h>
#import "DFPost.h"

typedef void(^CommentSuccessBlock)(DFPost *post);
typedef void(^CommentErrorBlock)(NSError *error);

@interface DFPost (Comment)

- (void)comment:(NSString *)commentString byUser:(DFUser *)user success:(CommentSuccessBlock)successBlock error:(CommentErrorBlock)errorBlock;

@end