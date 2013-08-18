#import <UIKit/UIKit.h>
#import "DFKeyboardViewController.h"

@class DFPost;

@protocol DFPostCommentDelegate

- (void)postComment:(NSString *)commentString toPost:(DFPost *)post;

@end

@interface DFPostCommentViewController : DFKeyboardViewController

@property (nonatomic, strong) DFPost *post;
@property (nonatomic, weak) id<DFPostCommentDelegate> delegate;

@end