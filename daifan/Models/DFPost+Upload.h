#import <Foundation/Foundation.h>
#import "DFPost.h"

@interface DFPost (Upload)

- (void)uploadWithImages:(NSArray *)images success:(PostSuccessBlock)successBlock error:(PostErrorBlock)errorBlock;

@end