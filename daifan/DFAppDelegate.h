#import <UIKit/UIKit.h>
#import "BPush.h"

@interface DFAppDelegate : UIResponder <UIApplicationDelegate, BPushDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDictionary *BPushDict;

@end
