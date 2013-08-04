#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat verticalCenter;
@property (nonatomic) CGFloat horizontalCenter;

@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

@end