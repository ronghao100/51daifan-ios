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
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];

        _messageLabel = [UILabel transparentLabelWithFrame:CGRectMake(141.0f, 0.0f, 160.0f, 12.0f)];
        _messageLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.text = @"";
        _messageLabel.bottom = FOOTER_VIEW_HEIGHT / 2.0f;
        [self addSubview:_messageLabel];

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator stopAnimating];
        _activityIndicator.verticalCenter = _messageLabel.verticalCenter;
        _activityIndicator.right = _messageLabel.left - 5.0f;
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
    _messageLabel.text = @"";

    [_activityIndicator stopAnimating];
    _refreshing = NO;
}

- (void)showHaveMore {
    _messageLabel.text = @"更多...";
}

- (void)showNoMore {
    _messageLabel.text = @"没有啦";
}

@end