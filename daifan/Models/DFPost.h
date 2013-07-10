#import <Foundation/Foundation.h>

@class DFUser;

@interface DFPost : NSObject

@property(nonatomic) long identity;
@property(nonatomic, strong) DFUser *user;
@property(nonatomic, strong) NSDate *publishDate;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *name;

@end