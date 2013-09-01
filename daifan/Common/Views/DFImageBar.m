#import "DFImageBar.h"

@implementation DFImageBar {
    NSMutableArray *_images;
    NSMutableArray *_imageViews;

    UIButton *_addPhoto;

    UILabel *_countLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];

        _maxImageCount = 6;
        _images = [[NSMutableArray alloc] init];
        _imageViews = [[NSMutableArray alloc] init];

        _addPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhoto.frame = CGRectMake(INSET_X, INSET_Y, DEFAULT_IMAGE_WIDTH, DEFAULT_IMAGE_WIDTH);
        _addPhoto.backgroundColor = [UIColor blueColor];
        [_addPhoto setTitle:@"+" forState:UIControlStateNormal];
        [_addPhoto addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addPhoto];

        CGFloat x = 275.0f;
        CGFloat w = 40.0f;
        _countLabel = [UILabel transparentLabelWithFrame:CGRectMake(x, INSET_Y, w, DEFAULT_IMAGE_HEIGHT)];
        _countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_countLabel];

        [self setCountLabel];
    }

    return self;
}

- (void)setCountLabel {
    _countLabel.text = ([NSString stringWithFormat:@"%d / %d", _images.count, _maxImageCount]);
}

- (void)addPhoto {
    if (!self.addPhotoClicked) {
        return;
    }

    self.addPhotoClicked();
}

- (NSArray *)images {
    return [_images copy];
}

- (NSUInteger)imageCount {
    return _images.count;
}

- (void)addImage:(UIImage *)image {
    NSLog(@"add photo %f, %f", image.size.width, image.size.height);
    [_images addObject:image];

    UIImageView *lastImageView = [_imageViews lastObject];
    CGFloat x = INSET_X;
    if (lastImageView) {
        x = lastImageView.right + INSET_X;
    }

    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.frame = CGRectMake(x, INSET_Y, DEFAULT_IMAGE_WIDTH, DEFAULT_IMAGE_HEIGHT);

    [_imageViews addObject:iv];
    [self addSubview:iv];

    _addPhoto.left += DEFAULT_IMAGE_WIDTH + INSET_X;

    [self setCountLabel];
    [self checkImageCount];
}

- (void)checkImageCount {
    if (_images.count >= _maxImageCount) {
        [_addPhoto removeFromSuperview];
    } else {
        if (_addPhoto.superview == nil) {
            [self addSubview:_addPhoto];
        }
    }
}

@end
