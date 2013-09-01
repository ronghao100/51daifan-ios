#import <UIKit/UIKit.h>

@interface UIImagePickerController (TakePicture)

+ (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;

+ (BOOL)startMediaBrowserFromViewController:(UIViewController *)controller
                              usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;

@end
