#import <UIKit/UIKit.h>

@interface DFComposeBaseViewController : UIViewController

- (void)relayoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration;

- (void)postContent;
- (void)cancel;

@end