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

- (void)showErrorMessage:(NSString *)message description:(NSString *)desc {
    [TSMessage showNotificationInViewController:self.navigationController == nil ? self : self.navigationController
                                          title:message
                                       subtitle:desc
                                           type:TSMessageNotificationTypeError];
}

- (void)showEndlessInfoMessage:(NSString *)message {
    [self showEndlessInfoMessage:message description:nil];
}

- (void)showEndlessInfoMessage:(NSString *)message description:(NSString *)desc {
    [TSMessage showNotificationInViewController:self.navigationController == nil ? self : self.navigationController
                                          title:message
                                       subtitle:desc
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationEndless
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

- (void)closeEndlessMessage {
    [TSMessage dismissActiveNotification];
}


@end