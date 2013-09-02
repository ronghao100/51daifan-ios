#import "DFPhotoShowViewController.h"
#import "UIGestureRecognizer+BlocksKit.h"


@implementation DFPhotoShowViewController {
    NSArray *_images;
    NSUInteger _currentIndex;

    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

- (id)initWithImages:(NSArray *)images index:(NSUInteger)index {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.wantsFullScreenLayout = YES;
        
        _images = images;
        _currentIndex = index;
    }

    return self;
}

#ifdef __IPHONE_7_0
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#endif

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.width += INSET_X * 2.0f;
    _scrollView.left = - INSET_X;
    [self.view addSubview:_scrollView];

    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;

    CGFloat height = self.view.height;

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, height - DEFAULT_BAR_HEIGHT, self.view.width, DEFAULT_BAR_HEIGHT)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView.contentSize = CGSizeMake((self.view.width + INSET_X * 2.0f) * _images.count, self.view.height);
    _scrollView.contentOffset = CGPointMake((self.view.width + INSET_X * 2.0f) * _currentIndex, 0.0f);

    CGFloat width = self.view.width;
    CGFloat height = self.view.height;

    [_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(INSET_X + (width + INSET_X * 2.0f) * idx, 0.0f, width, height)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:iv];

        NSString *imageURL = obj;
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"_thumb" withString:@""];

        [iv setImageWithURL:[NSURL URLWithString:imageURL]];
    }];

    _pageControl.numberOfPages = _images.count;
    _pageControl.currentPage = _currentIndex;

    [self addGestureRecognizers];
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *closeTapGR = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer * sender, UIGestureRecognizerState state, CGPoint location) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [self.view addGestureRecognizer:closeTapGR];
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentIndex = (NSUInteger)ceilf(_scrollView.contentOffset.x / (self.view.width + INSET_X * 2.0f));

    _pageControl.currentPage = _currentIndex;
}

#pragma mark - page control delegate




@end