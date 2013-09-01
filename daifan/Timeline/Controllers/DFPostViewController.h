#import <UIKit/UIKit.h>
#import "DFComposeBaseViewController.h"
#import "TCNumberSelector.h"
#import "TCDateSelector.h"


@protocol DFPostDelegate

- (void)post:(NSString *)postString date:(NSDate *)eatDate count:(NSInteger)totalCount;

@end

@interface DFPostViewController : DFComposeBaseViewController <UITextViewDelegate, TCSelectorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<DFPostDelegate> delegate;

@end