#import <UIKit/UIKit.h>
#import "ACTimeScroller.h"
#import "DFTimeLineCell.h"
#import "DFPostCommentViewController.h"

@class DFUser;

@interface DFTimeLineViewController : UITableViewController <ACTimeScrollerDelegate, DFTimeLineCellDelegate, DFPostCommentDelegate>

@property (nonatomic, strong) DFUser *currentUser;
@end