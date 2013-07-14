#import "DFRoundImageButton.h"


@implementation DFRoundImageButton {

}

- (void)setFrame:(CGRect)frame {
    frame.size.height = frame.size.width;
    [super setFrame:frame];

    CGFloat radius = self.frame.size.width / 2.0f;
    self.layer.cornerRadius = radius;

    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2.0f;

    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.75f;
}

@end