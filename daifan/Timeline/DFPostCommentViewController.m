#import "DFPostCommentViewController.h"


@implementation DFPostCommentViewController {
    UIImageView *_barImageView;
    UITextView *_commentView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;

        [self registerKeyboardNotification];
    }

    return self;
}

- (void)registerKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect = [aValue CGRectValue];

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [self moveInputBarWithKeyboardHeight:0.0f withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat newHeight = self.view.height - statusBarHeight - _barImageView.height - newKeyboardHeight;

    [UIView animateWithDuration:duration animations:^{
        _commentView.height = newHeight;
    }];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat yOffset = statusBarHeight;

    UIImage *barImage = [UIImage imageNamed:@"navigationBar.png"];
    _barImageView = [[UIImageView alloc] initWithImage:barImage];
    _barImageView.frame = CGRectMake(0.0f, yOffset, barImage.size.width, barImage.size.height);
    [self.view addSubview:_barImageView];

    UILabel *titleLabel = [UILabel transparentLabelWithFrame:_barImageView.frame];
    titleLabel.text = @"评论";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10.0f, yOffset + INSET_Y, 60.0f, 34.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];

    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(250.0f, yOffset + INSET_Y, 60.0f, 34.0f);
    [postButton setTitle:@"发送" forState:UIControlStateNormal];
    postButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];

    yOffset += _barImageView.height;

    _commentView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, yOffset, self.view.width, self.view.height - yOffset)];
    _commentView.contentInset = UIEdgeInsetsMake(INSET_Y, INSET_X, INSET_Y, INSET_X);
    _commentView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _commentView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self.view addSubview:_commentView];

    [_commentView becomeFirstResponder];
}

- (void)post {
    [_commentView resignFirstResponder];

    NSString *commentText = [_commentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSLog(@"post comment: %@", commentText);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end