#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)verticalCenter {
    CGRect rect = self.frame;
    return rect.origin.y + rect.size.height / 2.0f;
}

- (void)setVerticalCenter:(CGFloat)verticalCenter {
    CGRect rect = self.frame;
    rect.origin.y = verticalCenter - rect.size.height / 2.0f;
    self.frame = rect;
}

- (CGFloat)horizontalCenter {
    CGRect rect = self.frame;
    return rect.origin.x + rect.size.width / 2.0f;
}

- (void)setHorizontalCenter:(CGFloat)horizontalCenter {
    CGRect rect = self.frame;
    rect.origin.x = horizontalCenter - rect.size.width / 2.0f;
    self.frame = rect;
}

- (CGFloat)right {
    return self.left + self.width;
}

- (CGFloat)bottom {
    return self.top + self.height;
}


@end