#import "DFCoverView.h"


@implementation DFCoverView {
    UIImageView *_lineView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -568.0f, frame.size.width, frame.size.height + 568.0f)];
        bgView.backgroundColor = [UIColor orangeColor];
        [self addSubview:bgView];

        UIImage *line = [UIImage imageNamed:@"timeline.png"];

        _lineView = [[UIImageView alloc] initWithImage:line];

        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.frame = CGRectMake(66.0f, 66.0f, TIMELINE_WIDTH_NORMAL, COVER_VIEW_HEIGHT - 66.0f);
        [self addSubview:_lineView];
    }

    return self;
}

@end