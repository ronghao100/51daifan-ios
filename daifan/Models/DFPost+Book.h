#import <Foundation/Foundation.h>
#import "DFPost.h"

typedef void(^BookSuccessBlock)(DFPost *post, BOOL booked);
typedef void(^BookErrorBlock)(NSError *error, BOOL book);

@interface DFPost (Book)

- (void)bookOrUnbookByUser:(DFUser *)user success:(BookSuccessBlock)successBlock error:(BookErrorBlock)errorBlock;

@end