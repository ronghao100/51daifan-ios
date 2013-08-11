#import <UIKit/UIKit.h>


@interface DFFooterView : UIView

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, weak) id delegate;

- (void)beginRefreshing;
- (void)endRefreshing;

@end