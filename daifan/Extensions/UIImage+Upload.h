#import <UIKit/UIKit.h>

typedef void(^UploadFinishedBlock)(NSString *imageURL);


@interface UIImage (Upload)

- (void)upload:(UploadFinishedBlock)finishedBlock;

@end