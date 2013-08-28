#import <Foundation/Foundation.h>
#import "DFTimeline.h"

typedef void(^LoadSuccessBlock)(long newPostCount);
typedef void(^LoadErrorBlock)(NSError *error);
typedef void(^LoadCompleteBlock)(void);

@interface DFTimeline (Load)

- (void)loadList:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock complete:(LoadCompleteBlock)completeBlock;
- (void)pullForNew:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock complete:(LoadCompleteBlock)completeBlock;
- (void)loadMore:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock complete:(LoadCompleteBlock)completeBlock;

@end