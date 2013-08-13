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

    static DFUser *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[DFUser alloc] init];
        currentUser.identity = [[[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_ID] longValue];
        currentUser.name = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_NAME];
        currentUser.email = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER_EMAIL];
    });

    return currentUser;
}

@end