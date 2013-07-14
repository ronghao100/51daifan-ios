#import "DFLoginViewController.h"
#import "DFTimeLineViewController.h"


@implementation DFLoginViewController {
    UITextField *_userNameField;
    UITextField *_passwordField;

    UIButton *_loginButton;
    UIButton *_registerButton;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor orangeColor];

    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 100.0f, 40.0f, 30.0f)];
    [self.view addSubview:userNameLabel];
    userNameLabel.text = @"邮件:";

    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 170.0f, 30.0f)];
    [self.view addSubview:_userNameField];
    _userNameField.borderStyle = UITextBorderStyleRoundedRect;

    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 140.0f, 40.0f, 30.0f)];
    [self.view addSubview:passwordLabel];
    passwordLabel.text = @"密码:";

    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 140.0f, 170.0f, 30.0f)];
    [self.view addSubview:_passwordField];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;

    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_loginButton];
    _loginButton.frame = CGRectMake(100.0f, 180.0f, 150.0f, 44.0f);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_registerButton];
    _registerButton.frame = CGRectMake(100.0f, 234.0f, 150.0f, 44.0f);
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
}

- (void)login {
    DFTimeLineViewController *vc = [[DFTimeLineViewController alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}

@end