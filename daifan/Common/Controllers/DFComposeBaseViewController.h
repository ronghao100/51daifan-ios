#import <UIKit/UIKit.h>

@interface DFComposeBaseViewController : UIViewController

@property (nonatomic, strong) UIImageView *barImageView;

- (void)relayoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration;

- (void)postContent;
- (void)cancel;

@end