#import <UIKit/UIKit.h>
#import "ACTimeScroller.h"
#import "DFTimeLineCell.h"
#import "DFPostCommentViewController.h"
#import "DFPostViewController.h"

@class DFUser;

@interface DFTimeLineViewController : UITableViewController <ACTimeScrollerDelegate, DFTimeLineCellDelegate, DFPostCommentDelegate, DFPostDelegate>

@property (nonatomic, strong) DFUser *currentUser;

@end