#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"


@implementation DFTimeLineCell {
    UIImageView *_lineView;
    CGFloat _lineWidth;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *line = [UIImage imageNamed:@"line.png"];
        _lineWidth = line.size.width;

        _lineView = [[UIImageView alloc] initWithImage:line];

        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.frame = CGRectMake(66.0f, 0.0f, _lineWidth, self.frame.size.height);
        [self addSubview:_lineView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _lineView.frame = CGRectMake(66.0f, 0.0f, _lineWidth, self.frame.size.height);
}


@end