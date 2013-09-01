#import "UIImagePickerController+TakePicture.h"

@implementation UIImagePickerController (TakePicture)

+ (BOOL)startCameraControllerFromViewController:(UIViewController *)controller usingDelegate:(id <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>)delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera] == NO)
            || (delegate == nil)
            || (controller == nil))
        return NO;


    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

    cameraUI.mediaTypes =
            [UIImagePickerController availableMediaTypesForSourceType:
                    UIImagePickerControllerSourceTypeCamera];

    cameraUI.allowsEditing = NO;

    cameraUI.delegate = delegate;

    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

@end
