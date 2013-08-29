#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "DFUser.h"
#import "DFRemoteImageView.h"
#import "DFCommentView.h"

#define LABEL_WIDTH 248.0f
#define MIDDLE_LINE_X 62.0f
#define PADDING 10.0f

#define IMAGE_WIDTH 80.0f


@implementation DFTimeLineCell {
    UIImageView *_lineView;

    UIImageView *_avatarView;
    UILabel *_userNameLabel;

    UILabel *_contentLabel;

    UILabel *_publishDateLabel;

    UIImageView *_locationMark;
    UILabel *_addressLabel;

    UIButton *_commentButton;

    UIButton *_bookButton;

    UILabel *_countLabel;

    DFCommentView *_commentView;

    NSMutableArray *_imageViews;

    NSUInteger _imageCount;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *line = [UIImage imageNamed:@"timeline.png"];

        _lineView = [[UIImageView alloc] initWithImage:line];

        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.frame = CGRectMake(MIDDLE_LINE_X, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
//        [self addSubview:_lineView];

        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 10.0f, 48.0f, 48.0f)];
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

        _imageCount = 0;
        _imageViews = [[NSMutableArray alloc] initWithCapacity:3];

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

        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];

        _commentButton.frame = CGRectMake(278.0f, 0.0f, 44.0f, 44.0f);
        [self addSubview:_commentButton];

        _bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *bookImage = [UIImage imageNamed:@"book.png"];

        [_bookButton setImage:bookImage forState:UIControlStateNormal];
        [_bookButton setImage:[UIImage imageNamed:@"nomore.png"] forState:UIControlStateDisabled];
        [_bookButton addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];

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
        [self displayUserInfo];

        [self displayContent];

        [self displayImages];

        [self displayPublishDate];

        [self displayAddress];

        [self displayBookButton];

        [self displayFormattedCountLabel];

        [self displayCommentView];

        [self setNeedsLayout];
    } else {
        [self clearCellContent];
    }
}

- (void)displayUserInfo {
    [_avatarView setImageWithURL:[NSURL URLWithString:_post.user.avatarURLString]
                placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];

    _userNameLabel.text = _post.user.name;
}

- (void)displayContent {
    NSString *_contentWithComma = @"";
    if (_post.content.length > 0) {
        _contentWithComma = [NSString stringWithFormat:@": %@", _post.content];
    }

    NSString *_content = [NSString stringWithFormat:@"%@%@", _post.nameWithEatDate, _contentWithComma];
    _contentLabel.text = _content;
}

- (void)displayImages {
    NSLog(@"Images: %@", _post.images);

    [_post.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSLog(@"Image: %@", obj);
            NSString *urlString = obj;

            if ([urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
                UIImageView *iv;
                if (_imageCount >= _imageViews.count) {
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IMAGE_WIDTH, IMAGE_WIDTH)];
                    [_imageViews addObject:iv];
                }

                iv = _imageViews[_imageCount];
                [iv setImageWithURL:[NSURL URLWithString:urlString]];
                [self addSubview:iv];

                ++ _imageCount;
            }
        }
    }];

    NSLog(@"image count: %d, image view count: %d", _imageCount, _imageViews.count);
}

- (void)displayAddress {
    _addressLabel.text = _post.address;
    if (!_post.address || _post.address.length <= 0) {
            _addressLabel.hidden = YES;
            _locationMark.hidden = YES;
        }
}

- (void)displayPublishDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    dateFormatter.dateFormat = @"yyyy-M-d HH:mm发布";

    NSString *formattedPublishDate = [dateFormatter stringFromDate:_post.publishDate];
    _publishDateLabel.text = formattedPublishDate;
}

- (void)displayCommentView {
    _commentView.bookedUserIDs = _post.bookedUserIDs;
    _commentView.comments = _post.comments;
}

- (void)clearCellContent {
    _userNameLabel.text = @"";
    _contentLabel.text = @"";

    _imageCount = 0;
    [_imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *iv = obj;
        [iv setImageWithURL:nil];
        [iv removeFromSuperview];
    }];

    _publishDateLabel.text = @"";
    _addressLabel.text = @"";
    _addressLabel.hidden = NO;
    _locationMark.hidden = NO;

    _bookButton.enabled = YES;
    [_bookButton setImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];

    _countLabel.attributedText = nil;

    _commentView.comments = nil;

    [_avatarView cancelCurrentImageLoad];
    _avatarView.image = nil;
}

- (void)displayBookButton {
    if ([_post.bookedUserIDs containsObject:@([DFUser storedUser].identity).stringValue]) {
        [_bookButton setImage:[UIImage imageNamed:@"unbook.png"] forState:UIControlStateNormal];
        _bookButton.enabled = YES;
    } else {
        _bookButton.enabled = _post.count > _post.bookedCount;
    }
}

- (void)displayFormattedCountLabel {
    int remainCount = _post.count - _post.bookedCount;
    NSString *formattedCount = [NSString stringWithFormat:@"总共%d 还剩%d", _post.count, remainCount];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:formattedCount];

    NSUInteger countLength = @(_post.count).stringValue.length;
    NSUInteger remainLength = @(remainCount).stringValue.length;

    NSRange countRange = NSMakeRange(2, countLength);
    NSRange remainRange = NSMakeRange(formattedCount.length - remainLength, remainLength);

    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:COUNT_NUMBER_COLOR] range:countRange];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:COUNT_NUMBER_COLOR] range:remainRange];

    _countLabel.attributedText = attrString;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _contentLabel.top = _userNameLabel.bottom + INSET_Y;
    [_contentLabel fitToBestSize];

    CGFloat dataTop = _contentLabel.bottom + INSET_Y;
    CGFloat imageHeight = 0.0f;
    if (_imageCount > 0) {
        int x = 0;
        int y = 0;
        for (int i = 0; i < _imageCount; ++ i) {
            UIImageView *iv = _imageViews[i];
            x = i % 3;
            y = i / 3;

            iv.left = MIDDLE_LINE_X + (IMAGE_WIDTH + INSET_Y) * x;
            iv.top = _contentLabel.bottom + INSET_Y + (IMAGE_WIDTH + INSET_Y) * y;
        }

        dataTop = ((UIImageView *)_imageViews[_imageCount - 1]).bottom + INSET_Y;
        imageHeight = (y + 1) * (IMAGE_WIDTH + INSET_Y);
    }

    _publishDateLabel.top = dataTop;
    [_publishDateLabel fitToBestSize];

    _locationMark.top = _publishDateLabel.top;
    _locationMark.left = 180.0f;

    _addressLabel.top = _publishDateLabel.top;
    _addressLabel.left = _locationMark.right + 5.0f;
    [_addressLabel fitToBestSize];

    _commentButton.verticalCenter = _publishDateLabel.verticalCenter;

    _bookButton.top = _publishDateLabel.bottom + INSET_Y;

    [_countLabel fitToBestSize];
    _countLabel.verticalCenter = _bookButton.verticalCenter;

    _commentView.top = _bookButton.bottom + INSET_Y;

    CGFloat commentViewHeight = 0.0f;
    if (_post.bookedUserIDs.count > 0 || _post.comments.count > 0) {
        _commentView.hidden = NO;
        commentViewHeight = _commentView.height;
    } else {
        _commentView.hidden = YES;
    }

    CGFloat totalHeight = PADDING
                    + _userNameLabel.height + INSET_Y
                    + _contentLabel.height + INSET_Y
                    + imageHeight
                    + _publishDateLabel.height + INSET_Y
                    + _bookButton.height + INSET_Y
                    + commentViewHeight
                    + PADDING;

    self.height = totalHeight;
    _lineView.height = totalHeight;
}

- (void)book {
    [_delegate bookOnPost:_post];
}

- (void)comment {
    [_delegate commentOnPost:_post];
}

+ (CGFloat)heightForPost:(DFPost *)post {
    NSString *_content = [NSString stringWithFormat:@"%@: %@", post.nameWithEatDate, post.content];

    CGFloat contentHeight = [_content sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)].height;

    CGFloat imageHeight = 0.0f;
    NSUInteger imageCount = post.imageCount;
    if (imageCount > 0) {
        imageHeight = (IMAGE_WIDTH + INSET_Y) * (((imageCount - 1) / 3) + 1);
    }

    CGFloat commentViewHeight = 0.0f;
    if (post.bookedUserIDs.count > 0 || post.comments.count > 0) {
        DFCommentView *commentView = [[DFCommentView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, LABEL_WIDTH, 0.0f)];
        commentView.bookedUserIDs = post.bookedUserIDs;
        commentView.comments = post.comments;
        commentViewHeight = commentView.height;
    }

    return PADDING
         + 20.0f + INSET_Y
         + contentHeight + INSET_Y
         + imageHeight
         + 20.0f + INSET_Y
         + 20.0f + INSET_Y
         + commentViewHeight
         + PADDING;
}

@end