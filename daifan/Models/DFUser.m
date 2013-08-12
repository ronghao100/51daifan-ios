#import "DFUser.h"


@implementation DFUser {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"user id:%ld, name:%@, email:%@", self.identity, self.name, self.email];
}

@end