#import "DFSplashViewController.h"
#import "SSKeychain.h"
#import "DFTimeLineViewController.h"
#import "DFLoginViewController.h"

@implementation DFSplashViewController {

}

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

    [self setupCache];

    [self checkAccount];
}

- (void)checkAccount {
#ifdef DEBUG
    [NSThread sleepForTimeInterval:2];
#endif

    DFUser *user = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER];

//    NSArray *accounts = [SSKeychain accountsForService:kKEYCHAIN_SERVICE];

    if (user) {
        [self showTimelineView];
    } else {
        [self showLoginView];
    }
}

- (void)setupCache {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)showLoginView {
    DFLoginViewController *vc = [[DFLoginViewController alloc] init];

    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
}

- (void)showTimelineView {
    DFUser *user = [[NSUserDefaults standardUserDefaults] objectForKey:kCURRENT_USER];
    NSLog(@"got user: %@", user);

    DFTimeLineViewController *vc = [[DFTimeLineViewController alloc] init];
    vc.currentUser = user;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}

@end