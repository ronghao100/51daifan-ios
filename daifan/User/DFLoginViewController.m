#import <AFNetworking/AFHTTPRequestOperation.h>
#import <SSKeychain/SSKeychain.h>
#import "DFLoginViewController.h"
#import "DFTimeLineViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "DFUser.h"


@implementation DFLoginViewController {
    UITextField *_userNameField;
    UITextField *_passwordField;

    UIButton *_loginButton;
    UIButton *_registerButton;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationBounds];
    self.view.backgroundColor = [UIColor orangeColor];

    CGFloat minHeight = DEFAULT_BUTTON_HEIGHT * 2 + DEFAULT_TEXTFIELD_HEIGHT * 2 + DEFAULT_PADDING * 3;
    CGFloat viewHeight = self.view.frame.size.height - DEFAULT_KEYBOARD_HEIGHT;

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

    yOffset += DEFAULT_BUTTON_HEIGHT + DEFAULT_PADDING;

    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_registerButton];
    _registerButton.frame = CGRectMake(85.0f, yOffset, 150.0f, DEFAULT_BUTTON_HEIGHT);
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
}

- (void)login {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"^_^" message:@"hello" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    NSURL *url = [NSURL URLWithString:API_HOST];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:_userNameField.text forKey:@"email"];
    [parameters setValue:_passwordField.text forKey:@"password"];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:API_LOGIN_PATH parameters:parameters];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:postRequest
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                if ([[(NSDictionary *) JSON objectForKey:kRESPONSE_ERROR] boolValue]) {
                    [self showErrorMessage];
                } else {
                    [self saveAccount:JSON];
                    [self showTimelineView];
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self showErrorMessage];
            }];

    [httpClient enqueueHTTPRequestOperation:operation];
}

- (void)showErrorMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"亲，不记得账号密码了吗" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)saveAccount:(id)JSON {
    NSLog(@"%@", JSON);
    NSDictionary *userDict = [JSON objectForKey:kRESPONSE_USER];
    DFUser *user = [[DFUser alloc] init];
    user.identity = [[userDict objectForKey:@"id"] intValue];
    user.email = [userDict objectForKey:@"email"];
    user.name = [userDict objectForKey:@"name"];

    [SSKeychain setPassword:_passwordField.text forService:kKEYCHAIN_SERVICE account:user.email];
}

- (void)showTimelineView {
    DFTimeLineViewController *vc = [[DFTimeLineViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}


@end