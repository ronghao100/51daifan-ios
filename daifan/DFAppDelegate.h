#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>
#import "BPush.h"

@interface DFAppDelegate : UIResponder <UIApplicationDelegate, BPushDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDictionary *BPushDict;
@property (nonatomic, readonly, getter=isReachable) BOOL reachable;

@end
