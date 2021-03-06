#import <AFNetworking/AFHTTPRequestOperation.h>
#import <SSKeychain/SSKeychain.h>
#import "DFLoginViewController.h"
#import "DFTimeLineViewController.h"
#import "DFUser.h"
#import "DFAppDelegate.h"
#import "DFServices.h"


@implementation DFLoginViewController {
    UITextField *_userNameField;
    UITextField *_passwordField;

    UIButton *_loginButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";

        NSString *tintColorString = @"#5177D6";
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            tintColorString = @"#FFFFFF";
        }
        
        UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        registerButton.tintColor = [UIColor colorWithHexString:tintColorString];

        self.navigationItem.leftBarButtonItem = registerButton;
    }

    return self;
}

#ifdef __IPHONE_7_0
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#endif

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationBounds];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];

    CGFloat minHeight = DEFAULT_BUTTON_HEIGHT + DEFAULT_TEXTFIELD_HEIGHT * 2 + DEFAULT_PADDING * 3;
    CGFloat viewHeight = self.view.frame.size.height - DEFAULT_KEYBOARD_HEIGHT - DEFAULT_BAR_HEIGHT;

    CGFloat yOffset = (viewHeight - minHeight) / 2.0f;

    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, yOffset, 220.0f, DEFAULT_TEXTFIELD_HEIGHT)];
    [self.view addSubview:_userNameField];
    _userNameField.placeholder = @"邮箱";
    _userNameField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameField.keyboardType = UIKeyboardTypeEmailAddress;
    _userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_userNameField becomeFirstResponder];

    yOffset += DEFAULT_TEXTFIELD_HEIGHT + DEFAULT_PADDING;

    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, yOffset, 220.0f, DEFAULT_TEXTFIELD_HEIGHT)];
    [self.view addSubview:_passwordField];
    _passwordField.placeholder = @"密码";
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.clearsOnBeginEditing = YES;
    _passwordField.secureTextEntry = YES;

    yOffset += DEFAULT_TEXTFIELD_HEIGHT + DEFAULT_PADDING;

    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_loginButton];
    _loginButton.frame = CGRectMake(85.0f, yOffset, 150.0f, DEFAULT_BUTTON_HEIGHT);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

- (void)login {
    NSString *username = _userNameField.text;
    NSString *password = _passwordField.text;

    if (username.length == 0 || password.length == 0) {
        [self showWarningMessage:@"用户名和密码都要输入哦"];
        
        if (username.length == 0) {
            [_userNameField becomeFirstResponder];
        } else {
            [_passwordField becomeFirstResponder];
        }
        return;
    }

    if (!((DFAppDelegate *)([UIApplication sharedApplication].delegate)).isReachable) {
        [self showErrorMessage:@"网络不给力哦，亲"];
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:username forKey:@"email"];
    [parameters setValue:password forKey:@"password"];
    [parameters setValue:@"1" forKey:@"ver"];

    serviceCompleteBlock serviceBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        if (error) {
            [self showErrorMessage];
        } else {
            if ([[(NSDictionary *) JSON objectForKey:kRESPONSE_SUCCESS] integerValue] == RESPONSE_NOT_SUCCESS) {
                [self showErrorMessage];
            } else {
                DFUser *user = [self saveAccount:JSON];
                [user registerPN];
                [self showTimelineViewWithUser:user];
            }
        }
    };

    [DFServices postWithPath:API_LOGIN_PATH parameters:parameters completeBlock:serviceBlock];
}

- (void)register
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://51daifan.sinaapp.com/account/register" relativeToURL:nil]];
}

- (void)showErrorMessage {
    [self showErrorMessage:@"登陆失败" description:@"亲，不记得账号密码了吗"];
}

- (DFUser *)saveAccount:(id)JSON {
    NSLog(@"%@", JSON);
    NSDictionary *userDict = [JSON objectForKey:kRESPONSE_USER];
    DFUser *user = [[DFUser alloc] init];
    user.identity = [[userDict objectForKey:@"id"] intValue];
    user.email = [userDict objectForKey:@"email"];
    user.name = [userDict objectForKey:@"name"];
    user.avatarURLString = [userDict objectForKey:@"avatar_thumbnail"];

    [user storeToUserDefaults];

    NSLog(@"user saved: %@", user);

    [SSKeychain setPassword:_passwordField.text forService:kKEYCHAIN_SERVICE account:user.email];
    return user;
}

- (void)showTimelineViewWithUser:(DFUser *)user {
    DFTimeLineViewController *vc = [[DFTimeLineViewController alloc] init];
    vc.currentUser = user;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}

@end