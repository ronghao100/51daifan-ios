#import "DFSplashViewController.h"
#import "SSKeychain.h"
#import "DFTimeLineViewController.h"
#import "DFLoginViewController.h"

@implementation DFSplashViewController {

}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    UIImageView *splash = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:splash];
    splash.contentMode = UIViewContentModeCenter;

    NSString *splashImageName = [NSString stringWithFormat:@"Default%@.png", self.view.bounds.size.height == 568.0f ? @"-568h" : @""];
    splash.image = [UIImage imageNamed:splashImageName];

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicator];
    indicator.frame = CGRectMake(140.0f, 380.0f, indicator.frame.size.width, indicator.frame.size.height);
    [indicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self setupCache];

    [self checkAccount];

}

- (void)checkAccount {
    NSArray *accounts = [SSKeychain accountsForService:kKEYCHAIN_SERVICE];

//    if (accounts.count <= 0) {
        [self showLoginView];
//    } else {
//        [self showTimelineView];
//    }
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
    DFTimeLineViewController *vc = [[DFTimeLineViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}

@end