#import <Foundation/Foundation.h>
#import "DFPost.h"

typedef void(^BookSuccessBlock)(DFPost *post);
typedef void(^BookErrorBlock)(NSError *error);

@interface DFPost (Book)

- (void)bookOrUnbookByUser:(DFUser *)user success:(BookSuccessBlock)successBlock error:(BookErrorBlock)errorBlock;

@end