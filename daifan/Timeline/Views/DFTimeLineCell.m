#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"

#define INSET_Y 5.0f

@implementation DFTimeLineCell {
    UIImageView *_lineView;

    UIImageView *_avatarView;
    UILabel *_userNameLabel;
    UILabel *_descriptionLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *line = [UIImage imageNamed:@"timeline.png"];

        _lineView = [[UIImageView alloc] initWithImage:line];

        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.frame = CGRectMake(66.0f, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
        [self addSubview:_lineView];

        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(9.0f, 9.0f, 48.0f, 48.0f)];
        _avatarView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_avatarView];

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 9.0f, 235.0f, 20.0f)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];

        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 35.0f, 235.0f, 60.0f)];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_descriptionLabel];
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    _post = nil;
    [self refresh];
}

- (void)setPost:(DFPost *)post {
    _post = post;
    [self refresh];
}

- (void)refresh {
    if (_post) {
        _userNameLabel.text = _post.user.name;
        _descriptionLabel.text = _post.description;

        CGSize bestSize = [_descriptionLabel sizeThatFits:CGSizeMake(_descriptionLabel.frame.size.width, 0)];
        NSLog (@"Best Size: %f, %f", bestSize.width, bestSize.height);

        CGRect oldFrame = _descriptionLabel.frame;
        _descriptionLabel.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, bestSize.height);

        CGFloat totalHeight = bestSize.height + oldFrame.origin.y + INSET_Y;

        oldFrame = self.frame;
        oldFrame.size.height = totalHeight;
        self.frame = oldFrame;
    } else {
        _userNameLabel.text = @"";
        _descriptionLabel.text = @"";
    }

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _lineView.frame = CGRectMake(66.0f, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
}


@end