#import <UIKit/UIKit.h>


@interface DFPhotoShowViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithImages:(NSArray *)images index:(NSUInteger)index;

@end