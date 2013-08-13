#import "DFPost.h"
#import "DFUser.h"
#import "DFComment.h"


@implementation DFPost {

}

+ (DFPost *)postFromDict:(NSDictionary *)postDict {
    DFPost *post = [[DFPost alloc] init];

    post.identity = [[postDict objectForKey:@"objectId"] intValue];
    post.address = [postDict objectForKey:@"address"];
    post.name = [postDict objectForKey:@"name"];
    post.content = [postDict objectForKey:@"describe"];

    post.count = [[postDict objectForKey:@"count"] intValue];
    post.bookedCount = [[postDict objectForKey:@"bookedCount"] intValue];
    post.bookedUserIDs = [postDict objectForKey:@"bookedUids"];
    post.comments = [DFComment commentsFromArray:[postDict objectForKey:@"comments"]];

    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 6; i++) {
        NSString *image = [postDict objectForKey:[NSString stringWithFormat:@"image%d", i]];
        if (image) {
            [images addObject:image];
        }
    }
    post.images = images;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    post.publishDate = [dateFormatter dateFromString:[postDict objectForKey:@"createdAt"]];
    post.eatDate = [dateFormatter dateFromString:[postDict objectForKey:@"eatDate"]];
    post.updateDate = [dateFormatter dateFromString:[postDict objectForKey:@"updatedAt"]];

    DFUser *user = [[DFUser alloc] init];
    user.identity = [[postDict objectForKey:@"user"] intValue];
    user.name = [postDict objectForKey:@"realName"];
    user.avatarURLString = [postDict objectForKey:@"avatarThumbnail"];
    post.user = user;

    return post;
}

- (NSString *)nameWithEatDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    dateFormatter.dateFormat = @"M月d日";

    NSString *date = [dateFormatter stringFromDate:self.eatDate];
    return [NSString stringWithFormat:@"%@ 带 %@", date, self.name];
}

- (void)bookedByUser:(DFUser *)user {
    self.bookedCount ++;

    NSMutableArray *bookedList = [NSMutableArray arrayWithArray:self.bookedUserIDs];
    NSString *idString = [NSString stringWithFormat:@"%d", user.identity];
    [bookedList insertObject:idString atIndex:0];
    self.bookedUserIDs = [bookedList copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Post id:%d, name:%@, desc:%@, publishDate:%@, eatDate:%@", self.identity, self.name, self.content, self.publishDate, self.eatDate];
}


@end