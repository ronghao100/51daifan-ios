#import <Foundation/Foundation.h>

@interface UIViewController (ShowMessage)

#pragma mark - notification message

- (void)showSuccessMessage:(NSString *)message;
- (void)showWarningMessage:(NSString *)message;
- (void)showErrorMessage:(NSString *)message;

@end