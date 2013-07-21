#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"
#import "DFRemoteImageView.h"
#import "DFCommentView.h"

#define INSET_Y 5.0f
#define LABEL_WIDTH 235.0f

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

        _commentView = [[DFCommentView alloc] initWithFrame:CGRectMake(75.0f, 0.0f, LABEL_WIDTH, 0.0f)];
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

    _commentView.top = _contentLabel.bottom + INSET_Y;

    CGFloat totalHeight = 9.0f + 20.0f + INSET_Y + 20.0f + INSET_Y + _postNameLabel.height + INSET_Y + _contentLabel.height + INSET_Y + _commentView.height + 9.0f;

    self.height = totalHeight;
    _lineView.height = totalHeight;
}

+ (CGFloat)heightForPost:(DFPost *)post {
    CGFloat nameHeight = [post.nameWithEatDate sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;
    CGFloat contentHeight = [post.content sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;

    DFCommentView *commentView = [[DFCommentView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, LABEL_WIDTH, 0.0f)];
    commentView.comments = post.comments;

    NSLog(@"comment height: %f", commentView.height);

    return 9.0f + 20.0f + INSET_Y + 20.0f + INSET_Y + nameHeight + INSET_Y + contentHeight + INSET_Y + commentView.height + 9.0f;
}

@end