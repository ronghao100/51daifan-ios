#import <Foundation/Foundation.h>

@interface UIViewController (ShowMessage)

#pragma mark - notification message

- (void)showSuccessMessage:(NSString *)message;
- (void)showSuccessMessage:(NSString *)message description:(NSString *)desc;
- (void)showWarningMessage:(NSString *)message;
- (void)showWarningMessage:(NSString *)message description:(NSString *)desc;
- (void)showErrorMessage:(NSString *)message;
- (void)showErrorMessage:(NSString *)message description:(NSString *)desc;
- (void)showEndlessInfoMessage:(NSString *)message;
- (void)showEndlessInfoMessage:(NSString *)message description:(NSString *)desc;
- (void)closeEndlessMessage;

@end