#import "DFUser.h"


@implementation DFUser {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"user id:%ld, name:%@, email:%@", self.identity, self.name, self.email];
}

- (void)storeToUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.identity) forKey:kCURRENT_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:kCURRENT_USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.email forKey:kCURRENT_USER_EMAIL];
}

+ (BOOL)hasStoredUser {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] != nil;
}

+ (DFUser *)storedUser {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] == nil) {
        return nil;
    }

    DFUser *user = [[DFUser alloc] init];
    user.identity = [[[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] longValue];
    user.name = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_NAME];
    user.email = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_EMAIL];

    return user;
}

@end