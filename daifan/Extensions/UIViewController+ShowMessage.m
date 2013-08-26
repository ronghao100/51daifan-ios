#import "UIViewController+ShowMessage.h"
#import "TSMessage.h"


@implementation UIViewController (ShowMessage)

#pragma mark - notification message

- (void)showSuccessMessage:(NSString *)message {
    [TSMessage showNotificationInViewController:self.navigationController
                                          title:message
                                       subtitle:nil
                                           type:TSMessageNotificationTypeSuccess];
}

- (void)showWarningMessage:(NSString *)message {
    [TSMessage showNotificationInViewController:self.navigationController
                                          title:message
                                       subtitle:nil
                                           type:TSMessageNotificationTypeWarning];
}

- (void)showErrorMessage:(NSString *)message {
    [TSMessage showNotificationInViewController:self.navigationController
                                          title:message
                                       subtitle:nil
                                           type:TSMessageNotificationTypeError];
}

@end