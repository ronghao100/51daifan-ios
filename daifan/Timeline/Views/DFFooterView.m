#import <CoreGraphics/CoreGraphics.h>
#import "DFFooterView.h"


@implementation DFFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;

        CGFloat backgroundWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat backgroundHeight = [UIScreen mainScreen].bounds.size.height * 2.0f;

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, backgroundWidth, backgroundHeight)];
        bgView.backgroundColor = [UIColor blueColor];
        [self addSubview:bgView];

        UIImage *line = [UIImage imageNamed:@"timeline.png"];

        UIImageView *lineView = [[UIImageView alloc] initWithImage:line];
        lineView.contentMode = UIViewContentModeScaleToFill;
        lineView.frame = CGRectMake(66.0f, 0.0f, TIMELINE_WIDTH_NORMAL, backgroundHeight);
        [self addSubview:lineView];
    }

    return self;
}

@end