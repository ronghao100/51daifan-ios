#import <Foundation/Foundation.h>


@interface DFUser : NSObject

@property (nonatomic) long identity;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarURLString;

- (void)storeToUserDefaults;

+ (DFUser *)storedUser;

+ (BOOL)hasStoredUser;
@end