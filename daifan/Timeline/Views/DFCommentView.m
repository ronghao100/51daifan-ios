#import "DFCommentView.h"
#import "DFComment.h"
#import "DFUserList.h"

#define INSET_Y 5.0f
#define PADDING 10.0f

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

- (void)refresh {
    [_contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    __block CGFloat yOffset = PADDING;
    [_comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DFComment *comment = (DFComment *)obj;

        NSString *userName = [[DFUserList sharedList] userNameByID:comment.uid];
        NSString *commentString = [NSString stringWithFormat:@"%@: %@", userName, comment.content];

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commentString];

        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:NAME_LABEL_COLOR] range:NSMakeRange(0, userName.length)];

        NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentString.length)];

        UILabel *label = [UILabel transparentLabelWithFrame:CGRectMake(PADDING, yOffset, self.width - PADDING * 2.0f, 0.0f)];
        label.numberOfLines = 0;
        label.attributedText = attrString;

        [label fitToBestSize];

        yOffset += label.height + INSET_Y;

        [_contentView addSubview:label];
    }];

    _contentView.height = yOffset + PADDING;
    self.height = _arrowHeight + _contentView.height;

    [self setNeedsLayout];
}

@end