#import "DFCommentView.h"
#import "DFComment.h"
#import "DFUserList.h"

#define INSET_Y 5.0f
#define PADDING 10.0f

@implementation DFCommentView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
    }

    return self;
}

- (void)setComments:(NSArray *)comments {
    _comments = comments;

    [self refresh];
}

- (void)refresh {
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    __block CGFloat yOffset = 0.0f;
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

        [self addSubview:label];
    }];

    self.height = yOffset;

    [self setNeedsLayout];
}

@end