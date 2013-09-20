#import "DFPost+Book.h"
#import "DFUser.h"
#import "DFUserList.h"
#import "DFServices.h"

@implementation DFPost (Book)

- (void)bookByUser:(DFUser *)user success:(BookSuccessBlock)successBlock error:(BookErrorBlock)errorBlock {
    NSString *newerListString = [NSString stringWithFormat:API_BOOK_PARAMETER, self.identity, self.user.identity, self.user.name, user.identity, user.name];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_BOOK_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    serviceCompleteBlock serviceBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        NSDictionary *dict = (NSDictionary *) JSON;

        if (error) {
            NSLog(@"book failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            errorBlock(error, YES);
        } else if (dict && [[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
            errorBlock([NSError errorWithDomain:@"book" code:[[dict objectForKey:kRESPONSE_ERROR] integerValue] userInfo:nil], YES);
        } else {
            NSLog(@"book success.");

            [self bookedByUser:user];

            successBlock(self, YES);
        }
    };

    [DFServices getFromURLString:urlString completeBlock:serviceBlock];
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

    serviceCompleteBlock serviceBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        NSDictionary *dict = (NSDictionary *) JSON;

        if (error) {
            NSLog(@"unbook failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            errorBlock(error, NO);
        } else if (dict && [[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
            errorBlock([NSError errorWithDomain:@"unbook" code:[[dict objectForKey:kRESPONSE_ERROR] integerValue] userInfo:nil], NO);
        } else {
            NSLog(@"unbook success.");

            [self unbookedByUser:user];

            successBlock(self, NO);
        }
    };

    [DFServices getFromURLString:urlString completeBlock:serviceBlock];
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