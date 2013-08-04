#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"
#import "DFRemoteImageView.h"
#import "DFCommentView.h"

#define INSET_Y 5.0f
#define LABEL_WIDTH 248.0f
#define MIDDLE_LINE_X 62.0f
#define PADDING 10.0f


@implementation DFTimeLineCell {
    UIImageView *_lineView;

    DFRemoteImageView *_avatarView;
    UILabel *_userNameLabel;

    UILabel *_addressLabel;

    UILabel *_postNameLabel;
    UILabel *_contentLabel;

    DFCommentView *_commentView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *line = [UIImage imageNamed:@"timeline.png"];

        _lineView = [[UIImageView alloc] initWithImage:line];

        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.frame = CGRectMake(MIDDLE_LINE_X, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
        [self addSubview:_lineView];

        _avatarView = [[DFRemoteImageView alloc] initWithFrame:CGRectMake(7.0f, 10.0f, 48.0f, 48.0f)];
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_avatarView];

        _userNameLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 10.0f, LABEL_WIDTH, 20.0f)];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _userNameLabel.textColor = [UIColor colorWithHexString:NAME_LABEL_COLOR];
        [self addSubview:_userNameLabel];

        _addressLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 35.0f, LABEL_WIDTH, 20.0f)];
        [self addSubview:_addressLabel];

        _postNameLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 0.0f, LABEL_WIDTH, 0.0f)];
        _postNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _postNameLabel.numberOfLines = 0;
        [self addSubview:_postNameLabel];

        _contentLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 0.0f, LABEL_WIDTH, 0.0f)];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];

        _commentView = [[DFCommentView alloc] initWithFrame:CGRectMake(MIDDLE_LINE_X, 0.0f, LABEL_WIDTH, 0.0f)];
        [self addSubview:_commentView];
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
        _commentView.comments = _post.comments;
    } else {
        _userNameLabel.text = @"";
        _addressLabel.text = @"";
        _postNameLabel.text = @"";
        _contentLabel.text = @"";
        _commentView.comments = nil;

        [_avatarView stopLoading];
        _avatarView.image = nil;
    }

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _postNameLabel.top = _addressLabel.bottom + INSET_Y;
    [_postNameLabel fitToBestSize];

    _contentLabel.top = _postNameLabel.bottom + INSET_Y;
    [_contentLabel fitToBestSize];

    CGFloat commentViewHeight = 0.0f;
    if (_post.comments.count > 0) {
        _commentView.hidden = NO;
        _commentView.top = _contentLabel.bottom + INSET_Y;
        commentViewHeight = _commentView.height;
    } else {
        _commentView.hidden = YES;
    }

    CGFloat totalHeight = PADDING + 20.0f + INSET_Y + 20.0f + INSET_Y + _postNameLabel.height + INSET_Y + _contentLabel.height + INSET_Y + commentViewHeight + PADDING;

    self.height = totalHeight;
    _lineView.height = totalHeight;
}

+ (CGFloat)heightForPost:(DFPost *)post {
    CGFloat nameHeight = [post.nameWithEatDate sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;
    CGFloat contentHeight = [post.content sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;

    CGFloat commentViewHeight = 0.0f;
    if (post.comments.count > 0) {
        DFCommentView *commentView = [[DFCommentView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, LABEL_WIDTH, 0.0f)];
        commentView.comments = post.comments;
        commentViewHeight = commentView.height;
    }

    return PADDING + 20.0f + INSET_Y + 20.0f + INSET_Y + nameHeight + INSET_Y + contentHeight + INSET_Y + commentViewHeight + PADDING;
}

@end