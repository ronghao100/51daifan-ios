#import <UIKit/UIKit.h>

@class DFPost;

@protocol DFPostCommentDelegate

- (void)postComment:(NSString *)commentString toPost:(DFPost *)post;

@end

@interface DFPostCommentViewController : UIViewController

@property (nonatomic, strong) DFPost *post;
@property (nonatomic, weak) id<DFPostCommentDelegate> delegate;

@end