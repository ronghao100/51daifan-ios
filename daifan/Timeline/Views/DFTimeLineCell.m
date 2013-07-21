#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"
#import "DFRemoteImageView.h"

#define INSET_Y 5.0f
#define LABEL_WIDTH 235.0f

@implementation DFTimeLineCell {
    UIImageView *_lineView;

    DFRemoteImageView *_avatarView;
    UILabel *_userNameLabel;

    UILabel *_addressLabel;

    UILabel *_postNameLabel;
    UILabel *_contentLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *line = [UIImage imageNamed:@"timeline.png"];

        _lineView = [[UIImageView alloc] initWithImage:line];

        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.frame = CGRectMake(66.0f, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
        [self addSubview:_lineView];

        _avatarView = [[DFRemoteImageView alloc] initWithFrame:CGRectMake(9.0f, 9.0f, 48.0f, 48.0f)];
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_avatarView];

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 9.0f, LABEL_WIDTH, 20.0f)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];

        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 35.0f, LABEL_WIDTH, 20.0f)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_addressLabel];

        _postNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 0.0f, LABEL_WIDTH, 0.0f)];
        _postNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _postNameLabel.numberOfLines = 0;
        _postNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_postNameLabel];

        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 0.0f, LABEL_WIDTH, 0.0f)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
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
        [_avatarView loadImageFromURL:[NSURL URLWithString:_post.user.avatarURLString ]];

        _userNameLabel.text = _post.user.name;
        _addressLabel.text = _post.address;
        _postNameLabel.text = _post.nameWithEatDate;
        _contentLabel.text = _post.content;
    } else {
        _userNameLabel.text = @"";
        _addressLabel.text = @"";
        _postNameLabel.text = @"";
        _contentLabel.text = @"";
        [_avatarView stopLoading];
        _avatarView.image = nil;
    }

    [self setNeedsLayout];
}

- (void)fitToBestSizeOfLabel:(UILabel *)label {
    CGSize bestSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, 0)];

    CGRect oldFrame = label.frame;
    label.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, bestSize.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect oldFrame = _postNameLabel.frame;
    oldFrame.origin.y = _addressLabel.frame.origin.y + _addressLabel.frame.size.height + INSET_Y;
    _postNameLabel.frame = oldFrame;
    [self fitToBestSizeOfLabel:_postNameLabel];

    oldFrame = _contentLabel.frame;
    oldFrame.origin.y = _postNameLabel.frame.origin.y + _postNameLabel.frame.size.height + INSET_Y;
    _contentLabel.frame = oldFrame;
    [self fitToBestSizeOfLabel:_contentLabel];

    CGFloat totalHeight = 9.0f + 20.0f + INSET_Y + 20.0f + INSET_Y + _postNameLabel.frame.size.height + INSET_Y + _contentLabel.frame.size.height + 9.0f;

    oldFrame = self.frame;
    oldFrame.size.height = totalHeight;
    self.frame = oldFrame;

    _lineView.frame = CGRectMake(66.0f, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
}

+ (CGFloat)heightForPost:(DFPost *)post {
    CGFloat nameHeight = [post.nameWithEatDate sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;
    CGFloat contentHeight = [post.content sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;

    return 9.0f + 20.0f + INSET_Y + 20.0f + INSET_Y + nameHeight + INSET_Y + contentHeight + 9.0f;
}

@end