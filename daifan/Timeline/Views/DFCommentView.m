#import "DFCommentView.h"
#import "DFComment.h"
#import "DFUserList.h"

#define SPACING_X 5.0f
#define SPACING_Y 5.0f
#define INSET 10.0f

@implementation DFCommentView {
    UIImageView *_arrowView;
    UIView *_contentView;

    CGFloat _arrowHeight;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uparrow.png"]];
        _arrowView.left = 12.0f;
        _arrowView.top = 0.0f;
        [self addSubview:_arrowView];

        _arrowHeight = _arrowView.height;

        _contentView = [[UIView alloc] initWithFrame:self.frame];
        _contentView.left = 0.0f;
        _contentView.top = _arrowHeight;
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [self addSubview:_contentView];
    }

    return self;
}

- (void)setComments:(NSArray *)comments {
    _comments = comments;

    [self refresh];
}

- (void)setBookedUserIDs:(NSArray *)bookedUserIDs {
    _bookedUserIDs = bookedUserIDs;

    [self refresh];
}


- (void)refresh {
    [_contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    CGFloat labelWidth = self.width - INSET * 2.0f;

    __block CGFloat yOffset = INSET;
    if (_bookedUserIDs.count > 0) {
        UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueheart.png"]];
        heart.left = INSET;
        heart.top = yOffset;

        [_contentView addSubview:heart];

        __block NSMutableString *bookedListStr = [[NSMutableString alloc] init];
        [_bookedUserIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [bookedListStr appendFormat:@"%@ ", [[DFUserList sharedList] userNameByID:obj]];
        }];

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:bookedListStr];

        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:NAME_LABEL_COLOR] range:NSMakeRange(0, bookedListStr.length)];

        NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle alloc] init];
        paragraphStyle.firstLineHeadIndent = heart.width + SPACING_X;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, bookedListStr.length)];

        UILabel *bookedList = [UILabel transparentLabelWithFrame:CGRectMake(INSET, yOffset, labelWidth, 0.0f)];
        bookedList.numberOfLines = 0;
        bookedList.attributedText = attrString;
        [bookedList fitToBestSize];

        yOffset += MAX(heart.height, bookedList.height) + SPACING_Y;

        [_contentView addSubview:bookedList];
    }

    [_comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DFComment *comment = (DFComment *)obj;

        NSString *userName = [[DFUserList sharedList] userNameByID:comment.uid];
        NSString *commentString = [NSString stringWithFormat:@"%@: %@", userName, comment.content];

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commentString];

        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:NAME_LABEL_COLOR] range:NSMakeRange(0, userName.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:COMMENT_TEXT_COLOR] range:NSMakeRange(userName.length, commentString.length - userName.length)];

        NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentString.length)];

        UILabel *label = [UILabel transparentLabelWithFrame:CGRectMake(INSET, yOffset, labelWidth, 0.0f)];
        label.numberOfLines = 0;
        label.attributedText = attrString;
        [label fitToBestSize];

        yOffset += label.height + SPACING_Y;

        [_contentView addSubview:label];
    }];

    _contentView.height = yOffset + INSET;
    self.height = _arrowHeight + _contentView.height;

    [self setNeedsLayout];
}

@end