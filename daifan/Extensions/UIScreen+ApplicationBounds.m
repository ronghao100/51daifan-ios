#import "UIScreen+ApplicationBounds.h"


@implementation UIScreen (ApplicationBounds)

- (CGRect)applicationBounds {
    CGRect result = [self applicationFrame];
    result.origin = CGPointMake(0.0f, 0.0f);
    return result;
}

@end