#import "UIColor+Hex.h"


@implementation UIColor (Hex)

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha {
    return [UIColor
            colorWithRed:((float) ((hexValue & 0xFF0000) >> 16)) / 255.0
                   green:((float) ((hexValue & 0xFF00) >> 8)) / 255.0
                    blue:((float) (hexValue & 0xFF)) / 255.0
                   alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    UIColor *col;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue andAlpha:1.0f];
    } else {
        // invalid hex string
        col = [self blackColor];
    }
    return col;
}

@end