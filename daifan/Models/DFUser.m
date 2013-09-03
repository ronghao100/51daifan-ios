#import <AFNetworking/AFHTTPClient.h>
#import "DFUser.h"
#import "BPush.h"
#import "AFJSONRequestOperation.h"
#import "DFAppDelegate.h"


@implementation DFUser {

}

- (void)registerPN {
    NSDictionary *bpushDict = ((DFAppDelegate *)[UIApplication sharedApplication].delegate).BPushDict;

    if (bpushDict == nil) {
        NSLog(@"No BPush info now. skip.");
        return;
    }
    
    NSString *userid = [bpushDict valueForKey:BPushRequestUserIdKey];
    NSString *channelid = [bpushDict valueForKey:BPushRequestChannelIdKey];

    NSURL *url = [NSURL URLWithString:API_HOST];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:[@(self.identity) stringValue] forKey:@"userId"];
    [parameters setValue:userid forKey:@"pushUserId"];
    [parameters setValue:channelid forKey:@"pushChannelId"];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:API_PUSH_REGISTER_PATH parameters:parameters];

    NSLog(@"register pn request: %@, %@", postRequest, parameters);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:postRequest
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"pn registered: %@", JSON);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"pn register failed: %@", error);
            }];

    [httpClient enqueueHTTPRequestOperation:operation];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"user id:%ld, name:%@, email:%@", self.identity, self.name, self.email];
}

- (void)storeToUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.identity) forKey:kCURRENT_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:kCURRENT_USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.email forKey:kCURRENT_USER_EMAIL];
    [[NSUserDefaults standardUserDefaults] setObject:self.avatarURLString forKey:kCURRENT_USER_AVATAR];
}

+ (BOOL)hasStoredUser {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] != nil;
}

+ (DFUser *)storedUser {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] == nil) {
        return nil;
    }

    static DFUser *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[DFUser alloc] init];
        currentUser.identity = [[[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] longValue];
        currentUser.name = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_NAME];
        currentUser.email = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_EMAIL];
        currentUser.avatarURLString = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_AVATAR];
    });

    return currentUser;
}

@end