#import <UIKit/UIKit.h>

typedef void(^AddPhotoBlock)(void);


@interface DFImageBar : UIView

@property (nonatomic, readonly) NSArray *images;
@property (nonatomic, readonly) NSUInteger imageCount;

@property (nonatomic) NSUInteger maxImageCount;

@property (nonatomic, copy) AddPhotoBlock addPhotoClicked;

- (void)addImage:(UIImage *)image;

@end
