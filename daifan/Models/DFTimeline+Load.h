#import <Foundation/Foundation.h>
#import "DFTimeline.h"

typedef void(^LoadSuccessBlock)(long newPostCount);
typedef void(^LoadErrorBlock)(NSError *error);

@interface DFTimeline (Load)

- (void)loadList:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock;
- (void)pullForNew:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock;
- (void)loadMore:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock;

@end