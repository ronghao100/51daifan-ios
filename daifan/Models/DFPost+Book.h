#import <Foundation/Foundation.h>
#import "DFPost.h"

typedef void(^PostSuccessBlock)(DFPost *post);
typedef void(^PostErrorBlock)(NSError *error);

@interface DFPost (Book)

- (void)bookOrUnbookByUser:(DFUser *)user success:(PostSuccessBlock)successBlock error:(PostErrorBlock)errorBlock;

@end