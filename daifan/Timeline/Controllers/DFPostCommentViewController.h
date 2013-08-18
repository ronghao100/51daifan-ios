#import <UIKit/UIKit.h>
#import "DFComposeBaseViewController.h"

@class DFPost;

@protocol DFPostCommentDelegate

- (void)postComment:(NSString *)commentString toPost:(DFPost *)post;

@end

@interface DFPostCommentViewController : DFComposeBaseViewController

@property (nonatomic, strong) DFPost *post;
@property (nonatomic, weak) id<DFPostCommentDelegate> delegate;

@end