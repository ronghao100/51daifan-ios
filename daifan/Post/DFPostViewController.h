#import <UIKit/UIKit.h>

@class DFPost;

@interface DFPostViewController : UIViewController

- (id)initWithPost:(DFPost *)aPost;

@property (nonatomic, strong) DFPost *post;
@end