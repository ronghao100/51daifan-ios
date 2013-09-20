#import <AFNetworking/AFHTTPClient.h>
#import "DFUser.h"
#import "BPush.h"
#import "DFAppDelegate.h"
#import "DFServices.h"


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

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:[@(self.identity) stringValue] forKey:@"userId"];
    [parameters setValue:userid forKey:@"pushUserId"];
    [parameters setValue:channelid forKey:@"pushChannelId"];

    serviceCompleteBlock serviceBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        if (error) {
            NSLog(@"pn register failed: %@", error);
        } else {
            NSLog(@"pn registered: %@", JSON);
        }
    };

    [DFServices postWithPath:API_PUSH_REGISTER_PATH parameters:parameters completeBlock:serviceBlock];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"user id:%ld, name:%@, email:%@ avatar:%@", self.identity, self.name, self.email, self.avatarURLString];
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