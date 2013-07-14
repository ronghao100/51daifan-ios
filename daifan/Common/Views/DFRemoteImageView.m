#import "DFRemoteImageView.h"
#import "AFImageRequestOperation.h"


@implementation DFRemoteImageView {
    UIActivityIndicatorView *_activityIndicator;
    NSOperation *_operation;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.frame = self.bounds;

        [self addSubview:_activityIndicator];
        [self refreshIndicator];

        self.layer.cornerRadius = 6.0f;
        self.clipsToBounds = YES;
    }

    return self;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];

    [self refreshIndicator];
}

- (void)refreshIndicator {
    if (self.image) {
        [_activityIndicator stopAnimating];
    } else {
        [_activityIndicator startAnimating];
    }
}

- (void)loadImageFromURL:(NSURL *)imageURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    _operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        self.image = image;
    }];

    [_operation start];
}

- (void)stopLoading {
    if ([_operation isExecuting]) {
        [_operation cancel];
        self.image = nil;
    }
    _operation = nil;
}

@end