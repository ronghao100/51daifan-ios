#import <Foundation/Foundation.h>

@class DFUser;
@class DFComment;

@interface DFPost : NSObject

@property(nonatomic) long identity;
@property(nonatomic, strong) DFUser *user;
@property(nonatomic, strong) NSDate *publishDate;
@property(nonatomic, strong) NSDate *eatDate;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, readonly) NSString *nameWithEatDate;

@property(nonatomic) int count;
@property(nonatomic) int bookedCount;
@property(nonatomic, retain) NSArray *bookedUserIDs;
@property(nonatomic, retain) NSArray *comments;
@property(nonatomic, retain) NSArray *images;

@property(nonatomic, strong) NSDate *updateDate;

+ (DFPost *)postFromDict:(NSDictionary *)postDict;

- (NSComparisonResult)compare:(DFPost *)other;

@end