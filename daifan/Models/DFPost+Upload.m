#import "DFPost+Upload.h"
#import "DFUser.h"
#import "DFServices.h"


@implementation DFPost (Upload)

- (void)uploadWithImages:(NSArray *)images success:(PostSuccessBlock)successBlock error:(PostErrorBlock)errorBlock {
    _successBlock = [successBlock copy];
    _errorBlock = [errorBlock copy];
    _uploadedCount = 0;

    NSUInteger totalCount = images.count;

    if (totalCount == 0) {
        [self post];
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImage *image = obj;

            [image upload:^(NSString *imageURLString) {
                [self image:idx uploadedWithURLString:imageURLString totalCount:totalCount];
            }];
        }];
    });
}

- (void)image:(NSUInteger)index uploadedWithURLString:(NSString *)imageURLString totalCount:(NSUInteger)totalCount {
    if (imageURLString != nil) {
        [self.images addObject:imageURLString];
    }

    ++_uploadedCount;
    NSLog(@"uploaded count: %d", _uploadedCount);

    if (_uploadedCount >= totalCount) {
        [self post];
    }
}

- (void)post {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    df.timeZone = [NSTimeZone localTimeZone];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:@"1" forKey:@"ver"];
    [parameters setValue:[@(self.count) stringValue] forKey:@"count"];
    [parameters setValue:[df stringFromDate:self.eatDate] forKey:@"eatDate"];
    [parameters setValue:self.name forKey:@"name"];
    [parameters setValue:@"" forKey:@"desc"];
    [parameters setValue:self.images forKey:@"img"];
    [parameters setValue:[@(self.user.identity) stringValue] forKey:@"uid"];

    serviceCompleteBlock serviceBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        if (error) {
            NSLog(@"post failed in failure block: %@", error);
            _errorBlock(error);
        } else if ([[(NSDictionary *) JSON objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
            NSLog(@"post failed: %@", JSON);
            _errorBlock(nil);
        } else {
            NSLog(@"post succeed: %@", JSON);

            NSInteger postId = [[(NSDictionary *) JSON objectForKey:@"postid"] integerValue];
            self.identity = postId;

            _successBlock(self);
        }
    };

    [DFServices postWithPath:API_POST_PATH parameters:parameters completeBlock:serviceBlock];
}

@end