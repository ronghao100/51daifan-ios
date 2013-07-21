#import <Foundation/Foundation.h>

@class DFUser;


@interface DFUserList : NSObject

+ (DFUserList *)sharedList;

- (NSString *)userNameByID:(NSString *)userID;
- (void)mergeUserDict:(NSDictionary *)userDict;

@end