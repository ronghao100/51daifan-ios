#import "DFAppDelegate.h"
#import "DFSplashViewController.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation DFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationBounds]];

    DFSplashViewController *vc = [[DFSplashViewController alloc] init];
    self.window.rootViewController = vc;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
