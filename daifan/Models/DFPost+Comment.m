#import "DFPost+Comment.h"
#import "DFComment.h"
#import "DFUser.h"
#import "DFServices.h"


@implementation DFPost (Comment)

- (void)comment:(NSString *)commentString byUser:(DFUser *)user success:(CommentSuccessBlock)successBlock error:(CommentErrorBlock)errorBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:[@(self.identity) stringValue] forKey:@"postId"];
    [parameters setValue:[@(user.identity) stringValue] forKey:@"userId"];
    [parameters setValue:commentString forKey:@"comment"];

    serviceCompleteBlock serviceBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        if (error) {
            NSLog(@"comment post failed in failure block: %@", JSON);
            errorBlock(error);
        } else if ([[(NSDictionary *) JSON objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
            NSLog(@"comment post failed: %@", JSON);
            errorBlock([NSError errorWithDomain:@"comment" code:[[(NSDictionary *) JSON objectForKey:kRESPONSE_ERROR] integerValue] userInfo:nil]);
        } else {
            NSLog(@"comment post succeed: %@", JSON);
            [self commented:commentString byUser:user];

            successBlock(self);
        }
    };

    [DFServices postWithPath:API_COMMENT_PATH parameters:parameters completeBlock:serviceBlock];
}

- (void)commented:(NSString *)commentString byUser:(DFUser *)user {
    DFComment *comment = [[DFComment alloc] init];
    comment.uid = [@(user.identity) stringValue];
    comment.content = commentString;
    comment.commentTime = [NSDate date];

    NSMutableArray *mutableComments = [NSMutableArray arrayWithArray:self.comments];
    [mutableComments insertObject:comment atIndex:0];
    self.comments = [mutableComments copy];
}

@end