#import <Foundation/Foundation.h>


@interface DFUser : NSObject

@property (nonatomic) long identity;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarURLString;

@end