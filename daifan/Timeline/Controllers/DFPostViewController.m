#import "DFPostViewController.h"


@implementation DFPostViewController {
    UITextView *_postTextView;
    UIButton *_eatDateButton;
    UIButton *_countButton;
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
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat yOffset = statusBarHeight + self.barImageView.height;

    _eatDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _eatDateButton.frame = CGRectMake(0.0f, yOffset, halfWidth + 10.0f, DEFAULT_BAR_HEIGHT);
    [_eatDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eatDateButton addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eatDateButton];

    _countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _countButton.frame = CGRectMake(halfWidth + 10.0f, yOffset, halfWidth - 10.0f, DEFAULT_BAR_HEIGHT);
    [_countButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_countButton addTarget:self action:@selector(selectCount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_countButton];

    yOffset += DEFAULT_BAR_HEIGHT;

    _postTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, yOffset, self.view.width, self.view.height - yOffset - DEFAULT_BAR_HEIGHT)];
    _postTextView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _postTextView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _postTextView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_postTextView];

    [_postTextView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setEatDate:[NSDate tomorrow]];
    [self setTotalCount:0];
}

- (void)setEatDate:(NSDate *)date {
    _eatDate = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    dateFormatter.dateFormat = @"yyyy年M月d日 带";

    [_eatDateButton setTitle:[dateFormatter stringFromDate:_eatDate] forState:UIControlStateNormal];
}

- (void)setTotalCount:(NSUInteger)count {
    _totalCount = count;

    [_countButton setTitle:[NSString stringWithFormat:@"%d 份", _totalCount] forState:UIControlStateNormal];
}

- (void)selectDate {

}

- (void)selectCount {
    [self setTotalCount:self.totalCount + 1];
}

- (void)postContent {
    [_postTextView resignFirstResponder];

    NSString *postText = [_postTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

//    [super postContent];
}

- (void)relayoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat newHeight = self.view.height - statusBarHeight - self.barImageView.height - newKeyboardHeight - DEFAULT_BAR_HEIGHT;

    [UIView animateWithDuration:duration animations:^{
        _postTextView.height = newHeight;
    }];
}

@end