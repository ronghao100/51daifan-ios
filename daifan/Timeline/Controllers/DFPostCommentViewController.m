#import "DFPostCommentViewController.h"


@implementation DFPostCommentViewController {
    UITextView *_commentView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发评论";
    }

    return self;
}

- (void)relayoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration {
    CGFloat newHeight = self.view.height - newKeyboardHeight;

    [UIView animateWithDuration:duration animations:^{
        _commentView.height = newHeight;
    }];
}

- (void)loadView {
    [super loadView];

    _commentView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)];
    _commentView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _commentView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _commentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_commentView];

    [_commentView becomeFirstResponder];
}

- (void)postContent {
    NSString *commentText = [_commentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (commentText.length == 0) {
        [self showErrorMessage:@"要输入内容哦，亲"];
        [_commentView becomeFirstResponder];
        return;
    }

    [_commentView resignFirstResponder];

    [_delegate postComment:commentText toPost:_post];

    [super postContent];
}

@end