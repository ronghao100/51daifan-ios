#import <AFNetworking/AFJSONRequestOperation.h>
#import <AFNetworking/AFHTTPClient.h>
#import "DFPost+Comment.h"
#import "DFComment.h"
#import "DFUser.h"


@implementation DFPost (Comment)

- (void)comment:(NSString *)commentString byUser:(DFUser *)user success:(CommentSuccessBlock)successBlock error:(CommentErrorBlock)errorBlock {
    NSURL *url = [NSURL URLWithString:API_HOST];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:[@(self.identity) stringValue] forKey:@"postId"];
    [parameters setValue:[@(user.identity) stringValue] forKey:@"userId"];
    [parameters setValue:commentString forKey:@"comment"];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:API_COMMENT_PATH parameters:parameters];

    NSLog(@"request: %@, %@", postRequest, parameters);

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:postRequest
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                if ([[(NSDictionary *) JSON objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                    NSLog(@"comment post failed: %@", JSON);
                    errorBlock([NSError errorWithDomain:@"comment" code:[[(NSDictionary *) JSON objectForKey:kRESPONSE_ERROR] integerValue] userInfo:nil]);
                } else {
                    NSLog(@"comment post succeed: %@", JSON);
                    [self commented:commentString byUser:user];

                    successBlock(self);
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"comment post failed in failure block: %@", JSON);
                errorBlock(error);
            }];

    [httpClient enqueueHTTPRequestOperation:operation];
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