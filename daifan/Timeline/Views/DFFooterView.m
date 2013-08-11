#import <CoreGraphics/CoreGraphics.h>
#import "DFFooterView.h"


@implementation DFFooterView {
    UILabel *_messageLabel;
    UIActivityIndicatorView *_activityIndicator;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;

        CGFloat backgroundWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat backgroundHeight = [UIScreen mainScreen].bounds.size.height * 2.0f;

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, backgroundWidth, backgroundHeight)];
        bgView.backgroundColor = [UIColor blueColor];
        [self addSubview:bgView];

        _messageLabel = [UILabel transparentLabelWithFrame:CGRectMake(0.0f, 0.0f, backgroundWidth, 12.0f)];
        _messageLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"";
        _messageLabel.bottom = FOOTER_VIEW_HEIGHT / 2.0f - 5.0f;
        [self addSubview:_messageLabel];

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator stopAnimating];
        _activityIndicator.horizontalCenter = backgroundWidth / 2.0f;
        _activityIndicator.top = _messageLabel.bottom + 5.0f;
        [self addSubview:_activityIndicator];
    }

    return self;
}

- (void)beginRefreshing {
    _refreshing = YES;
    [_activityIndicator startAnimating];

    _messageLabel.text = @"获取中...";

    if ([_delegate respondsToSelector:@selector(loadMore)]) {
        [_delegate performSelector:@selector(loadMore)];
    }
}

- (void)endRefreshing {
    _messageLabel.text = @"更多...";

    [_activityIndicator stopAnimating];
    _refreshing = NO;
}

@end