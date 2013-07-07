#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"

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

        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0f, 3.0f, 60.0f, 60.0f)];
        _avatarView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_avatarView];

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 66.0f, 60.0f, 15.0f)];
        [self addSubview:_userNameLabel];

        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 3.0f, 240.0f, 60.0f)];
        _descriptionLabel.numberOfLines = 0;
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