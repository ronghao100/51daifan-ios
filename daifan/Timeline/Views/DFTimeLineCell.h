#import <UIKit/UIKit.h>

@class DFPost;

@interface DFTimeLineCell : UITableViewCell

@property (nonatomic, strong) DFPost *post;

+ (CGFloat)heightForPost:(DFPost *)post;

@end