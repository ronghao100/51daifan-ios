#import "UILabel+FitToBestSize.h"


@implementation UILabel (FitToBestSize)

- (void)fitToBestSize {
    CGSize bestSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, 0)];

    CGRect oldFrame = self.frame;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, bestSize.height);
}

@end