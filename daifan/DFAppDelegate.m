#import "DFAppDelegate.h"
#import "DFSplashViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BPush.h"
#import "JSONKit.h"
#import "DFUser.h"
#import "Reachability.h"
#import <Crashlytics/Crashlytics.h>

@implementation DFAppDelegate {
    NetworkStatus _currentStatus;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    [self initReachabilityProcessor];

    [self initBPush:launchOptions];

    [Crashlytics startWithAPIKey:@"14d75c31a7b5949c98944925d2d58251190b1de3"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    DFSplashViewController *vc = [[DFSplashViewController alloc] init];
    self.window.rootViewController = vc;

    [self initBarAppearance];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    return YES;
}

- (void)initReachabilityProcessor {
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];

    reach.reachableBlock = ^(Reachability *aReach)
    {
        _currentStatus = aReach.currentReachabilityStatus;
    };

    reach.unreachableBlock = ^(Reachability *aReach)
    {
        _currentStatus = aReach.currentReachabilityStatus;
    };

    [reach startNotifier];
}

- (BOOL)isReachable {
    return (_currentStatus != NotReachable);
}


- (void)initBPush:(NSDictionary *)launchOptions {
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
}

- (void)initBarAppearance {
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        UIImage *barImage = [UIImage imageNamed:@"navigationBarTall.png"];
        [[UINavigationBar appearance] setBackgroundImage:barImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    } else {
        UIImage *barImage = [UIImage imageNamed:@"navigationBar.png"];
        [[UINavigationBar appearance] setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    }
#else
    UIImage *barImage = [UIImage imageNamed:@"navigationBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
#endif
}

- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"pushed method: %@, data: %@", method, data);
    
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        self.BPushDict = res;

        if ([DFUser hasStoredUser]) {
            [[DFUser storedUser] registerPN];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"failed to register for PN with error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
//    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    if (application.applicationState == UIApplicationStateActive) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息哦"
//                                                            message:alert
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
}


@end
