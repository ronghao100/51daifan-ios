#import "DFPostViewController.h"
#import "DFPost.h"


@implementation DFPostViewController {

}

- (id)initWithPost:(DFPost *)aPost {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.post = aPost;

        [self initGestureRecognizer];
    }

    return self;
}

- (void)initGestureRecognizer {
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)swiped:(UIGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

@end