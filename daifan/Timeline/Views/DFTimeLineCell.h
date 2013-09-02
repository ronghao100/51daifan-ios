#import <UIKit/UIKit.h>

@class DFPost;

@protocol DFTimeLineCellDelegate

- (void)bookOnPost:(DFPost *)post;
- (void)commentOnPost:(DFPost *)post;

- (void)imageAtIndexClicked:(NSUInteger)index;

@end

@interface DFTimeLineCell : UITableViewCell

@property (nonatomic, strong) DFPost *post;
@property (nonatomic, weak) id<DFTimeLineCellDelegate> delegate;

+ (CGFloat)heightForPost:(DFPost *)post;

@end