#import "DFPostCommentViewController.h"


@implementation DFPostCommentViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
//    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationBounds];
    self.view.backgroundColor = [UIColor orangeColor];

    UIImage *barImage = [UIImage imageNamed:@"navigationBar.png"];
    UIImageView *barImageView = [[UIImageView alloc] initWithImage:barImage];
    barImageView.frame = CGRectMake(0.0f, 0.0f, barImage.size.width, barImage.size.height);
    [self.view addSubview:barImageView];

    UILabel *titleLabel = [UILabel transparentLabelWithFrame:barImageView.frame];
    titleLabel.text = @"评论";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(10.0f, 5.0f, 60.0f, 34.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];

    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = CGRectMake(250.0f, 5.0f, 60.0f, 34.0f);
    [postButton setTitle:@"发送" forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];

    UITextField *commentField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.width, self.view.height - barImageView.height - DEFAULT_KEYBOARD_HEIGHT)];
    commentField.placeholder = @"评论";
    [self.view addSubview:commentField];

}


- (void)post {

}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end