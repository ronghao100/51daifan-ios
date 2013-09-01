#import "DFPostViewController.h"
#import "UIViewController+ShowMessage.h"


@implementation DFPostViewController {
    UITextView *_postTextView;

    TCDateSelector *_eatDateSelector;
    TCNumberSelector *_countSelector;

    UIButton *_addPhoto;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发布";
    }

    return self;
}

- (void)loadView {
    [super loadView];

    CGFloat halfWidth = self.view.width / 2.0f;
    CGFloat yOffset = 0.0f;

    _eatDateSelector = [[TCDateSelector alloc] initWithFrame:CGRectMake(0.0f, yOffset, halfWidth, DEFAULT_BAR_HEIGHT) date:[NSDate tomorrow]];
    _eatDateSelector.textColor = [UIColor blackColor];
    _eatDateSelector.format = @"yyyy年M月d日";
    _eatDateSelector.delegate = self;
    [self.view addSubview:_eatDateSelector];

    _countSelector = [[TCNumberSelector alloc] initWithFrame:CGRectMake(halfWidth, yOffset, halfWidth, DEFAULT_BAR_HEIGHT) number:1];
    _countSelector.textColor = [UIColor blackColor];
    _countSelector.format = @"带 %d 份";
    _countSelector.minimumNumber = 1;
    _countSelector.delegate = self;
    [self.view addSubview:_countSelector];

    yOffset += DEFAULT_BAR_HEIGHT;

    _postTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, yOffset, self.view.width, self.view.height - yOffset - DEFAULT_BAR_HEIGHT)];
    _postTextView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _postTextView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _postTextView.showsHorizontalScrollIndicator = NO;
    _postTextView.delegate = self;
    [self.view addSubview:_postTextView];
    [self.view sendSubviewToBack:_postTextView];

    _addPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPhoto.frame = CGRectMake(INSET_X, _postTextView.bottom - INSET_Y - DEFAULT_BUTTON_HEIGHT, DEFAULT_BUTTON_WIDTH, DEFAULT_BUTTON_HEIGHT);
    _addPhoto.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:DEFAULT_ALPHA];
    [_addPhoto setTitle:@"+" forState:UIControlStateNormal];
    [_addPhoto addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addPhoto];

    [_postTextView becomeFirstResponder];
}

- (void)postContent {
    NSString *postText = [_postTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (postText.length == 0) {
        [self showErrorMessage:@"要输入内容哦，亲"];
        [_postTextView becomeFirstResponder];
        return;
    }

    [_postTextView resignFirstResponder];

    NSDate *eatDate = _eatDateSelector.date;
    NSInteger totalCount = _countSelector.number;

    [_delegate post:postText date:eatDate count:totalCount];

    [super postContent];
}

- (void)layoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration {
    CGFloat newHeight = self.view.height - newKeyboardHeight - DEFAULT_BAR_HEIGHT;

    [UIView animateWithDuration:duration animations:^{
        _postTextView.height = newHeight;
        _addPhoto.top = _postTextView.bottom - INSET_Y - DEFAULT_BUTTON_HEIGHT;
    }];
}

#pragma mark - TCSelector delegate
- (void)selectorWillExtended:(TCSelectorBaseView *)selector {
    [_postTextView resignFirstResponder];

    if ([selector isEqual:_eatDateSelector]) {
        [_countSelector collapse];
    } else {
        [_eatDateSelector collapse];
    }
}

- (void)selectorDidCollapsed:(TCSelectorBaseView *)selector {
    if (_eatDateSelector.isExtended || _countSelector.isExtended) {
        return;
    }

    [_postTextView becomeFirstResponder];
}

#pragma mark - TextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_eatDateSelector collapse];
    [_countSelector collapse];
}

#pragma mark - Camera

- (void)showCamera {
    [UIImagePickerController startCameraControllerFromViewController:self usingDelegate:self];
}

@end