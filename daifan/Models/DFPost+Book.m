#import <AFNetworking/AFJSONRequestOperation.h>
#import "DFPost+Book.h"
#import "DFUser.h"
#import "DFUserList.h"

@implementation DFPost (Book)

- (void)bookByUser:(DFUser *)user success:(BookSuccessBlock)successBlock error:(BookErrorBlock)errorBlock {
    NSString *newerListString = [NSString stringWithFormat:API_BOOK_PARAMETER, self.identity, self.user.identity, self.user.name, user.identity, user.name];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_BOOK_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSDictionary *dict = (NSDictionary *) JSON;

                if ([[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                    errorBlock([NSError errorWithDomain:@"book" code:[[dict objectForKey:kRESPONSE_ERROR] integerValue] userInfo:nil]);
                    return;
                }
                NSLog(@"book success.");

                [self bookedByUser:user];

                successBlock(self);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"book failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
                errorBlock(error);
            }];
    [operation start];
}

- (void)bookedByUser:(DFUser *)user {
    self.bookedCount++;

    NSMutableArray *bookedList = [NSMutableArray arrayWithArray:self.bookedUserIDs];
    NSString *idString = [NSString stringWithFormat:@"%ld", user.identity];
    [bookedList insertObject:idString atIndex:0];
    self.bookedUserIDs = [bookedList copy];

    [[DFUserList sharedList] mergeUserDict:@{@(user.identity).stringValue : user.name}];
}

- (void)unbookByUser:(DFUser *)user success:(BookSuccessBlock)successBlock error:(BookErrorBlock)errorBlock {
    NSString *newerListString = [NSString stringWithFormat:API_UNBOOK_PARAMETER, self.identity, user.identity];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_UNBOOK_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"unbook success.");
                NSDictionary *dict = (NSDictionary *) JSON;

                if ([[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                    errorBlock([NSError errorWithDomain:@"unbook" code:[[dict objectForKey:kRESPONSE_ERROR] integerValue] userInfo:nil]);
                    return;
                }

                [self unbookedByUser:user];

                successBlock(self);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"book failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
                errorBlock(error);
            }];
    [operation start];
}

- (void)unbookedByUser:(DFUser *)user {
    self.bookedCount--;

    NSMutableArray *bookedList = [NSMutableArray arrayWithArray:self.bookedUserIDs];
    NSString *idString = [NSString stringWithFormat:@"%ld", user.identity];
    [bookedList removeObject:idString];
    self.bookedUserIDs = [bookedList copy];
}

- (void)bookOrUnbookByUser:(DFUser *)user success:(BookSuccessBlock)successBlock error:(BookErrorBlock)errorBlock {
    if ([self.bookedUserIDs containsObject:@(user.identity).stringValue]) {
        [self unbookByUser:user success:successBlock error:errorBlock];
    } else {
        [self bookByUser:user success:successBlock error:errorBlock];
    }
}

@end