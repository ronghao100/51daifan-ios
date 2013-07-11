#import <UIKit/UIKit.h>

@interface DFRemoteImageView : UIImageView

- (void)loadImageFromURL:(NSURL *)imageURL;
- (void)stopLoading;

@end