#import "DFCommentView.h"
#import "DFComment.h"
#import "DFUserList.h"

#define INSET_Y 5.0f

@implementation DFCommentView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
        NSString *commentString = [NSString stringWithFormat:@"%@ %@", userName, comment.content];

        NSRange nameRange = NSMakeRange(0, userName.length);
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commentString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:nameRange];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, yOffset, self.width, 0.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.attributedText = attrString;

        [label fitToBestSize];

        yOffset += label.height + INSET_Y;

        [self addSubview:label];
    }];

    self.height = yOffset;

    [self setNeedsLayout];
}

@end