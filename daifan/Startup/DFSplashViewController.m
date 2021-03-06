#import "DFSplashViewController.h"
#import "DFTimeLineViewController.h"
#import "DFLoginViewController.h"
#import "DFUser.h"

@implementation DFSplashViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;
    }

    return self;
}

#ifdef __IPHONE_7_0
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#endif

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    NSString *splashImageName = [NSString stringWithFormat:@"Default%@.png", self.view.bounds.size.height == 568.0f ? @"-568h" : @""];

    UIImageView *splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:splashImageName]];
    [self.view addSubview:splash];
    splash.contentMode = UIViewContentModeCenter;

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicator];
    indicator.frame = CGRectMake(140.0f, 260.0f, indicator.frame.size.width, indicator.frame.size.height);
    [indicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self checkAccount];
}

- (void)checkAccount {
#ifdef DEBUG
    [NSThread sleepForTimeInterval:2];
#endif

    if ([DFUser hasStoredUser]) {
        [self showTimelineView];
    } else {
        [self showLoginView];
    }
}

- (void)showLoginView {
    DFLoginViewController *vc = [[DFLoginViewController alloc] init];

    [UIApplication sharedApplication].delegate.window.rootViewController = [vc aroundWithNavigation];
}

- (void)showTimelineView {
    DFUser *user = [DFUser storedUser];
    [user registerPN];

    NSLog(@"got stored user: %@", user);

    DFTimeLineViewController *vc = [[DFTimeLineViewController alloc] init];
    vc.currentUser = user;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}

@end