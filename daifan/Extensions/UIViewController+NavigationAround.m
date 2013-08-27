#import "UIViewController+NavigationAround.h"


@implementation UIViewController (NavigationAround)

- (UINavigationController *)aroundWithNavigation {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];

    return nav;
}

@end