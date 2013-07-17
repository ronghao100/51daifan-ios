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
    UILabel *_postNameLabel;
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

        _avatarView = [[DFRemoteImageView alloc] initWithFrame:CGRectMake(9.0f, 9.0f, 48.0f, 48.0f)];
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_avatarView];

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 9.0f, LABEL_WIDTH, 20.0f)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];

        _postNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 35.0f, LABEL_WIDTH, 0.0f)];
        _postNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _postNameLabel.numberOfLines = 0;
        _postNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_postNameLabel];

        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 60.0f, LABEL_WIDTH, 0.0f)];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
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
        [_avatarView loadImageFromURL:[NSURL URLWithString:_post.user.avatarURLString ]];

        _userNameLabel.text = _post.user.name;
        _postNameLabel.text = _post.name;
        _descriptionLabel.text = _post.description;
    } else {
        _userNameLabel.text = @"";
        _postNameLabel.text = @"";
        _descriptionLabel.text = @"";
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

    [self fitToBestSizeOfLabel:_postNameLabel];

    CGRect oldFrame = _descriptionLabel.frame;
    oldFrame.origin.y = _postNameLabel.frame.origin.y + _postNameLabel.frame.size.height + INSET_Y;
    _descriptionLabel.frame = oldFrame;
    [self fitToBestSizeOfLabel:_descriptionLabel];

    CGFloat totalHeight = 9.0f + 20.0f + INSET_Y + _postNameLabel.frame.size.height + INSET_Y + _descriptionLabel.frame.size.height + 9.0f;

    oldFrame = self.frame;
    oldFrame.size.height = totalHeight;
    self.frame = oldFrame;

    NSLog(@"cell height: %f", self.frame.size.height);
    _lineView.frame = CGRectMake(66.0f, 0.0f, TIMELINE_WIDTH_NORMAL, self.frame.size.height);
}

+ (CGFloat)heightForPost:(DFPost *)post {
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.numberOfLines = 0;

    testLabel.text = post.name;
    testLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    CGFloat nameHeight = [testLabel sizeThatFits:CGSizeMake(LABEL_WIDTH, 0)].height;

    testLabel.text = post.description;
    testLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGFloat descriptionHeight = [testLabel sizeThatFits:CGSizeMake(LABEL_WIDTH, 0)].height;

//    CGFloat nameHeight = [post.name sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, 0.0f)].height;
//    CGFloat descriptionHeight = [post.description sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:CGSizeMake(LABEL_WIDTH, 0.0f)].height;

    NSLog(@"name: %@ height: %f", post.name, nameHeight);
    NSLog(@"desc: %@ height: %f", post.description, descriptionHeight);

    return 9.0f + 20.0f + INSET_Y + nameHeight + INSET_Y + descriptionHeight + 9.0f;
}

@end