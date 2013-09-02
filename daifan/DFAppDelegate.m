#import "DFAppDelegate.h"
#import "DFSplashViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BPush.h"
#import "JSONKit.h"
#import <Crashlytics/Crashlytics.h>

@implementation DFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];

    [Crashlytics startWithAPIKey:@"12cf69bcd58555af123af07396580d08d970eee1"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    DFSplashViewController *vc = [[DFSplashViewController alloc] init];
    self.window.rootViewController = vc;

#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        UIImage *barImage = [UIImage imageNamed:@"navigationBarTall.png"];
        application.statusBarStyle = UIStatusBarStyleDefault;
        [[UINavigationBar appearance] setBackgroundImage:barImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    } else {
        UIImage *barImage = [UIImage imageNamed:@"navigationBar.png"];
        application.statusBarStyle = UIStatusBarStyleDefault;
        [[UINavigationBar appearance] setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    }
#else
    UIImage *barImage = [UIImage imageNamed:@"navigationBar.png"];
    application.statusBarStyle = UIStatusBarStyleDefault;
    [[UINavigationBar appearance] setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
#endif
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    return YES;
}

- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"pushed method: %@, data: %@", method, data);
    
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        self.BPushDict = res;
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
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息哦"
                                                            message:alert
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
}


@end
