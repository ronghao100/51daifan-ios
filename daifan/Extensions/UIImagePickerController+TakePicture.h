#import <UIKit/UIKit.h>

@interface UIImagePickerController (TakePicture)

+ (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                   UINavigationControllerDelegate>) delegate;
@end
