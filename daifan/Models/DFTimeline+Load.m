#import "DFTimeline+Load.h"
#import "AFJSONRequestOperation.h"
#import "DFUserList.h"
#import "DFPost.h"


@implementation DFTimeline (Load)

#pragma mark - Services

- (void)loadList:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POSTS_PATH, API_POSTS_NEW_LIST_PARAMETER];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSDictionary *dict = (NSDictionary *) JSON;

                if ([[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                    errorBlock([NSError errorWithDomain:@"loadlist" code:RESPONSE_CODE_BAD_REQUEST userInfo:nil]);
                    return;
                }

                NSLog(@"time line success.");
                NSArray *posts = [dict objectForKey:kRESPONSE_POSTS];

                NSDictionary *users = [dict objectForKey:kRESPONSE_BOOKED_USER_ID];
                [[DFUserList sharedList] mergeUserDict:users];

                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DFPost *post = [DFPost postFromDict:obj];
                    [self addPost:post];
                }];

                NSLog(@"time line:%@", self);

                successBlock(posts.count);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
                errorBlock(error);
            }];
    [operation start];
}

- (void)pullForNew:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock {
    NSString *newerListString = [NSString stringWithFormat:API_POSTS_NEWER_LIST_PARAMETER, self.newestPostID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POSTS_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSDictionary *dict = (NSDictionary *) JSON;

                if ([[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                    errorBlock([NSError errorWithDomain:@"pullfornew" code:RESPONSE_CODE_BAD_REQUEST userInfo:nil]);
                    return;
                }

                NSLog(@"time line newer success.");
                NSArray *posts = [dict objectForKey:kRESPONSE_POSTS];

                NSUInteger newerPostCount = posts.count;

                if (newerPostCount > 0) {
                    NSDictionary *users = [dict objectForKey:kRESPONSE_BOOKED_USER_ID];
                    [[DFUserList sharedList] mergeUserDict:users];

                    [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        DFPost *post = [DFPost postFromDict:obj];
                        [self addPost:post];
                    }];

                    NSLog(@"time line:%@", self);

                    successBlock(newerPostCount);
                } else {
                    errorBlock([NSError errorWithDomain:@"pullfornew" code:RESPONSE_CODE_NO_CONTENT userInfo:nil]);
                }

            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
                errorBlock(error);
            }];
    [operation start];
}

- (void)loadMore:(LoadSuccessBlock)successBlock error:(LoadErrorBlock)errorBlock {
    NSString *newerListString = [NSString stringWithFormat:API_POSTS_OLDER_LIST_PARAMETER, self.oldestPostID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POSTS_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSDictionary *dict = (NSDictionary *) JSON;

                if ([[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                    errorBlock([NSError errorWithDomain:@"loadmore" code:RESPONSE_CODE_BAD_REQUEST userInfo:nil]);
                    return;
                }

                NSLog(@"time line older success.");
                NSArray *posts = [dict objectForKey:kRESPONSE_POSTS];

                NSDictionary *users = [dict objectForKey:kRESPONSE_BOOKED_USER_ID];
                [[DFUserList sharedList] mergeUserDict:users];

                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DFPost *post = [DFPost postFromDict:obj];
                    [self addPost:post];
                }];

                NSLog(@"time line:%@", self);

                successBlock(posts.count);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
                errorBlock(error);
            }];
    [operation start];
}

@end