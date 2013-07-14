#import "DFCoverView.h"
#import "DFRoundImageButton.h"


@implementation DFCoverView {
    UIImageView *_lineView;
    DFRoundImageButton *_selfButton;
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
        _lineView.frame = CGRectMake(66.0f, COVER_VIEW_HEIGHT - 34.0f, TIMELINE_WIDTH_NORMAL, 34.0f);
        [self addSubview:_lineView];

        _selfButton = [DFRoundImageButton buttonWithType:UIButtonTypeCustom];
        _selfButton.frame = CGRectMake(45.0f, COVER_VIEW_HEIGHT - 34.0f - 44.0f - 20.0f, 44.0f, 44.0f);
        _selfButton.backgroundColor = [UIColor orangeColor];
        [self addSubview:_selfButton];
    }

    return self;
}

@end