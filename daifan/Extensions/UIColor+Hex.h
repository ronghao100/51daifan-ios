#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end