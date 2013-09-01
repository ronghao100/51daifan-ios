#import <UIKit/UIKit.h>

@interface DFComposeBaseViewController : UIViewController

- (void)layoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration;

- (void)postContent;
- (void)cancel;

@end