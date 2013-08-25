#import "DFPost.h"
#import "DFUser.h"
#import "DFComment.h"

@implementation DFPost {

}

- (id)init {
    self = [super init];
    if (self) {
        self.address = @"";
        self.content = @"";
        self.bookedCount = 0;
        self.bookedUserIDs = @[];
        self.comments = @[];
        self.images = @[];
    }

    return self;
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


- (void)addComment:(DFComment *)comment {
    NSMutableArray *mutableComments = [NSMutableArray arrayWithArray:self.comments];
    [mutableComments insertObject:comment atIndex:0];
    self.comments = [mutableComments copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Post eatDate:%@, id:%ld, name:%@, desc:%@, publishDate:%@", self.eatDate, self.identity, self.name, self.content, self.publishDate];
}

- (NSComparisonResult)compare:(DFPost *)other
{
    if (other == nil) {
        return NSOrderedAscending;
    }

    if (self.identity == other.identity) {
        return NSOrderedSame;
    }

    NSComparisonResult comparisonResult = [self.eatDate compare:other.eatDate];
    if (comparisonResult == NSOrderedSame) {
        if (self.identity > other.identity) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    } else if (comparisonResult == NSOrderedAscending) {
        return NSOrderedDescending;
    } else {
        return NSOrderedAscending;
    }
}

@end