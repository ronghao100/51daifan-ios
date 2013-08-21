#import "DFPostCommentViewController.h"


@implementation DFPostCommentViewController {
    UITextView *_commentView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"评论";
    }

    return self;
}

- (void)relayoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat newHeight = self.view.height - statusBarHeight - self.barImageView.height - newKeyboardHeight;

    [UIView animateWithDuration:duration animations:^{
        _commentView.height = newHeight;
    }];
}

- (void)loadView {
    [super loadView];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat yOffset = statusBarHeight + self.barImageView.height;

    _commentView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, yOffset, self.view.width, self.view.height - yOffset)];
    _commentView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _commentView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _commentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_commentView];

    [_commentView becomeFirstResponder];
}

- (void)postContent {
    [_commentView resignFirstResponder];

    NSString *commentText = [_commentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [_delegate postComment:commentText toPost:_post];

    [super postContent];
}

@end