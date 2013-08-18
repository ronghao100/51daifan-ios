#import <UIKit/UIKit.h>

@interface DFKeyboardViewController : UIViewController

- (void)relayoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration;

@end