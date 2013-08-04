#import <CoreGraphics/CoreGraphics.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"
#import "DFRemoteImageView.h"
#import "DFCommentView.h"

#define INSET_X 5.0f
#define INSET_Y 5.0f
#define LABEL_WIDTH 248.0f
#define MIDDLE_LINE_X 62.0f
#define PADDING 10.0f


@implementation DFTimeLineCell {
    UIImageView *_lineView;

    DFRemoteImageView *_avatarView;
    UILabel *_userNameLabel;

    UILabel *_contentLabel;

    UILabel *_publishDateLabel;

    UIImageView *_locationMark;
    UILabel *_addressLabel;

    UIButton *_bookButton;

    UILabel *_countLabel;

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

        _userNameLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, PADDING, LABEL_WIDTH, 20.0f)];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _userNameLabel.textColor = [UIColor colorWithHexString:NAME_LABEL_COLOR];
        [self addSubview:_userNameLabel];

        _contentLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 0.0f, LABEL_WIDTH, 0.0f)];
        _contentLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];

        _publishDateLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 0.0f, LABEL_WIDTH, 20.0f)];
        _publishDateLabel.font = [UIFont systemFontOfSize:9.0f];
        _publishDateLabel.textColor = [UIColor colorWithHexString:SUBTITLE_LABEL_COLOR];
        [self addSubview:_publishDateLabel];

        _locationMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location.png"]];
        [self addSubview:_locationMark];

        _addressLabel = [UILabel transparentLabelWithFrame:CGRectMake(MIDDLE_LINE_X, 0.0f, LABEL_WIDTH, 20.0f)];
        _addressLabel.font = [UIFont systemFontOfSize:9.0f];
        _addressLabel.textColor = [UIColor colorWithHexString:SUBTITLE_LABEL_COLOR];
        [self addSubview:_addressLabel];

        _bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *bookImage = [UIImage imageNamed:@"book.png"];

        [_bookButton setImage:bookImage forState:UIControlStateNormal];
        [_bookButton setImage:[UIImage imageNamed:@"nomore.png"] forState:UIControlStateDisabled];

        _bookButton.frame = CGRectMake(MIDDLE_LINE_X, 0.0f, bookImage.size.width, bookImage.size.height);
        [self addSubview:_bookButton];

        _countLabel = [UILabel transparentLabelWithFrame:CGRectMake(_bookButton.right + INSET_X, 0.0f, LABEL_WIDTH, 20.0f)];
        _countLabel.font = [UIFont systemFontOfSize:11.0f];
        _countLabel.textColor = [UIColor colorWithHexString:COUNT_LABEL_COLOR];
        [self addSubview:_countLabel];

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
        NSString *_content = [NSString stringWithFormat:@"%@: %@", _post.nameWithEatDate, _post.content];
        _contentLabel.text = _content;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        dateFormatter.dateFormat = @"yyyy-M-d HH:mm发布";

        NSString *formatedPublishDate = [dateFormatter stringFromDate:_post.publishDate];
        _publishDateLabel.text = formatedPublishDate;

        _addressLabel.text = _post.address;
        if (!_post.address || _post.address.length <= 0) {
            _addressLabel.hidden = YES;
            _locationMark.hidden = YES;
        }

        _bookButton.enabled = _post.count > _post.bookedCount;

        NSString *formatedCount = [NSString stringWithFormat:@"总共%d 还剩%d", _post.count, _post.count - _post.bookedCount];
        _countLabel.text = formatedCount;

        _commentView.comments = _post.comments;
    } else {
        _userNameLabel.text = @"";
        _contentLabel.text = @"";
        _publishDateLabel.text = @"";

        _addressLabel.text = @"";
        _addressLabel.hidden = NO;
        _locationMark.hidden = NO;

        _bookButton.enabled = YES;

        _countLabel.text = @"";

        _commentView.comments = nil;

        [_avatarView stopLoading];
        _avatarView.image = nil;
    }

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _contentLabel.top = _userNameLabel.bottom + INSET_Y;
    [_contentLabel fitToBestSize];

    _publishDateLabel.top = _contentLabel.bottom + INSET_Y;
    [_publishDateLabel fitToBestSize];

    _locationMark.top = _publishDateLabel.top;
    _locationMark.left = 180.0f;

    _addressLabel.top = _publishDateLabel.top;
    _addressLabel.left = _locationMark.right + 5.0f;
    [_addressLabel fitToBestSize];

    _bookButton.top = _publishDateLabel.bottom + INSET_Y;

    [_countLabel fitToBestSize];
    _countLabel.verticalCenter = _bookButton.verticalCenter;

    _commentView.top = _bookButton.bottom + INSET_Y;

    CGFloat commentViewHeight = 0.0f;
    if (_post.comments.count > 0) {
        _commentView.hidden = NO;
        commentViewHeight = _commentView.height;
    } else {
        _commentView.hidden = YES;
    }

    CGFloat totalHeight = PADDING
                    + _userNameLabel.height + INSET_Y
                    + _contentLabel.height + INSET_Y
                    + _publishDateLabel.height + INSET_Y
                    + _bookButton.height + INSET_Y
                    + commentViewHeight
                    + PADDING;

    self.height = totalHeight;
    _lineView.height = totalHeight;
}

+ (CGFloat)heightForPost:(DFPost *)post {
    NSString *_content = [NSString stringWithFormat:@"%@: %@", post.nameWithEatDate, post.content];

    CGFloat contentHeight = [_content sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;

    CGFloat commentViewHeight = 0.0f;
    if (post.comments.count > 0) {
        DFCommentView *commentView = [[DFCommentView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, LABEL_WIDTH, 0.0f)];
        commentView.comments = post.comments;
        commentViewHeight = commentView.height;
    }

    return PADDING
         + 20.0f + INSET_Y
         + contentHeight + INSET_Y
         + 20.0f + INSET_Y
         + 20.0f + INSET_Y
         + commentViewHeight
         + PADDING;
}

@end