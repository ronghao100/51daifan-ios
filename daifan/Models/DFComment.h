#import <Foundation/Foundation.h>


@interface DFComment : NSObject

@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *rate;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSDate *commentTime;

+ (DFComment *)commentFromDict:(NSDictionary *)commentDict;
+ (NSArray *)commentsFromArray:(NSArray *)commentsArray;

@end