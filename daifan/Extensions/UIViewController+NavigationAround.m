#import "UIViewController+NavigationAround.h"


@implementation UIViewController (NavigationAround)

- (UINavigationController *)aroundWithNavigation {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];

    return nav;
}

@end