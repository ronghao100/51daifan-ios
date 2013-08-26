#import "UIViewController+ShowMessage.h"
#import "TSMessage.h"


@implementation UIViewController (ShowMessage)

#pragma mark - notification message

- (void)showSuccessMessage:(NSString *)message {
    [self showSuccessMessage:message description:nil];
}

- (void)showSuccessMessage:(NSString *)message description:(NSString *)desc {
    [TSMessage showNotificationInViewController:self.navigationController == nil ? self : self.navigationController
                                          title:message
                                       subtitle:desc
                                           type:TSMessageNotificationTypeSuccess];
}

- (void)showWarningMessage:(NSString *)message {
    [self showWarningMessage:message description:nil];
}

- (void)showWarningMessage:(NSString *)message description:(NSString *)desc {
    [TSMessage showNotificationInViewController:self.navigationController == nil ? self : self.navigationController
                                          title:message
                                       subtitle:desc
                                           type:TSMessageNotificationTypeWarning];
}

- (void)showErrorMessage:(NSString *)message {
    [self showErrorMessage:message description:nil];
}

- (void)showErrorMessage:(NSString *)message description:(NSString *)desc{
    [TSMessage showNotificationInViewController:self.navigationController == nil ? self : self.navigationController
                                          title:message
                                       subtitle:desc
                                           type:TSMessageNotificationTypeError];
}

@end