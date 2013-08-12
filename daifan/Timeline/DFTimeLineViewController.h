#import <UIKit/UIKit.h>
#import "ACTimeScroller.h"
#import "DFTimeLineCell.h"

@class DFUser;

@interface DFTimeLineViewController : UITableViewController <ACTimeScrollerDelegate, DFTimeLineCellDelegate>

@property (nonatomic, strong) DFUser *currentUser;
@end