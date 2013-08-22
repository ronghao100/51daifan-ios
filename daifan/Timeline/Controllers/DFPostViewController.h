#import <UIKit/UIKit.h>
#import "DFComposeBaseViewController.h"
#import "TCNumberSelector.h"
#import "TCDateSelector.h"


@interface DFPostViewController : DFComposeBaseViewController <UITextViewDelegate, TCSelectorDelegate>

@property (nonatomic, readonly) NSDate *eatDate;
@property (nonatomic, readonly) NSInteger totalCount;

@end