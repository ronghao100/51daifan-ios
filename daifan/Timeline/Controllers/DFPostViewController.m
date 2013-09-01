#import "DFPostViewController.h"
#import "UIViewController+ShowMessage.h"
#import "UIImage+Resize.h"
#import "DFImageBar.h"


@implementation DFPostViewController {
    UITextView *_postTextView;

    TCDateSelector *_eatDateSelector;
    TCNumberSelector *_countSelector;

    DFImageBar *_imageBar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发布";
    }

    return self;
}

- (void)loadView {
    [super loadView];

    CGFloat halfWidth = self.view.width / 2.0f;
    CGFloat yOffset = 0.0f;

    _eatDateSelector = [[TCDateSelector alloc] initWithFrame:CGRectMake(0.0f, yOffset, halfWidth, DEFAULT_BAR_HEIGHT) date:[NSDate tomorrow]];
    _eatDateSelector.textColor = [UIColor blackColor];
    _eatDateSelector.format = @"yyyy年M月d日";
    _eatDateSelector.delegate = self;
    [self.view addSubview:_eatDateSelector];

    _countSelector = [[TCNumberSelector alloc] initWithFrame:CGRectMake(halfWidth, yOffset, halfWidth, DEFAULT_BAR_HEIGHT) number:1];
    _countSelector.textColor = [UIColor blackColor];
    _countSelector.format = @"带 %d 份";
    _countSelector.minimumNumber = 1;
    _countSelector.delegate = self;
    [self.view addSubview:_countSelector];

    yOffset += DEFAULT_BAR_HEIGHT;

    float imageBarHeight = DEFAULT_IMAGE_HEIGHT + INSET_Y * 2.0f;

    _postTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, yOffset, self.view.width, self.view.height - yOffset - DEFAULT_BAR_HEIGHT - imageBarHeight)];
    _postTextView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _postTextView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _postTextView.showsHorizontalScrollIndicator = NO;
    _postTextView.delegate = self;
    [self.view addSubview:_postTextView];
    [self.view sendSubviewToBack:_postTextView];

    _imageBar = [[DFImageBar alloc] initWithFrame:CGRectMake(0.0f, _postTextView.bottom - imageBarHeight, self.view.width, imageBarHeight)];
    __weak DFPostViewController *weakSelf = self;
    _imageBar.addPhotoClicked = ^() {
        [weakSelf showCamera];
    };
    [self.view addSubview:_imageBar];

    [_postTextView becomeFirstResponder];
}

- (void)postContent {
    NSString *postText = [_postTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (postText.length == 0) {
        [self showErrorMessage:@"要输入内容哦，亲"];
        [_postTextView becomeFirstResponder];
        return;
    }

    [_postTextView resignFirstResponder];

    NSDate *eatDate = _eatDateSelector.date;
    NSInteger totalCount = _countSelector.number;

    [_delegate post:postText images:_imageBar.images date:eatDate count:totalCount];

    [super postContent];
}

- (void)layoutViewWithKeyboardHeight:(CGFloat)newKeyboardHeight withDuration:(NSTimeInterval)duration {
    CGFloat newHeight = self.view.height - newKeyboardHeight - DEFAULT_BAR_HEIGHT - INSET_Y * 2.0f - DEFAULT_IMAGE_HEIGHT;

    [UIView animateWithDuration:duration animations:^{
        _postTextView.height = newHeight;
        _imageBar.top = _postTextView.bottom;
    }];
}

#pragma mark - TCSelector delegate
- (void)selectorWillExtended:(TCSelectorBaseView *)selector {
    [_postTextView resignFirstResponder];

    if ([selector isEqual:_eatDateSelector]) {
        [_countSelector collapse];
    } else {
        [_eatDateSelector collapse];
    }
}

- (void)selectorDidCollapsed:(TCSelectorBaseView *)selector {
    if (_eatDateSelector.isExtended || _countSelector.isExtended) {
        return;
    }

    [_postTextView becomeFirstResponder];
}

#pragma mark - TextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_eatDateSelector collapse];
    [_countSelector collapse];
}

#pragma mark - Camera

- (void)showCamera {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"图片库", nil];
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [UIImagePickerController startCameraControllerFromViewController:self usingDelegate:self];
    } else if (buttonIndex == 1) {
        [UIImagePickerController startMediaBrowserFromViewController:self usingDelegate:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage, *editedImage, *imageToSave;

    editedImage = (UIImage *) [info objectForKey:
            UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
            UIImagePickerControllerOriginalImage];

    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
    }

    UIImage *imageToPost = [imageToSave resizedImageToFitInSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE) scaleIfSmaller:NO];

    [picker dismissViewControllerAnimated:YES completion:nil];

    [_imageBar addImage:imageToPost];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end