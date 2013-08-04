#import "UILabel+TransparentFactory.h"


@implementation UILabel (TransparentFactory)

+ (id)transparentLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end