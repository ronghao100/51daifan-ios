#import "UIImagePickerController+TakePicture.h"

@implementation UIImagePickerController (TakePicture)

+ (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {

    return [UIImagePickerController openImagePickerWithType:UIImagePickerControllerSourceTypeCamera
                                         fromViewController:controller
                                              usingDelegate:delegate];
}

+ (BOOL)startMediaBrowserFromViewController:(UIViewController *)controller
                              usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    return [UIImagePickerController openImagePickerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum
                                         fromViewController:controller
                                              usingDelegate:delegate];
}

+ (BOOL)openImagePickerWithType:(UIImagePickerControllerSourceType)type
             fromViewController:(UIViewController *)controller
                  usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
            || (delegate == nil)
            || (controller == nil))
        return NO;

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = type;
    cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;

    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}
@end
