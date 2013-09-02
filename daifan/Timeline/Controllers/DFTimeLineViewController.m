#import "DFTimeLineViewController.h"
#import "DFPost.h"
#import "AFJSONRequestOperation.h"
#import "DFUserList.h"
#import "DFFooterView.h"
#import "DFUser.h"
#import "AFHTTPClient.h"
#import "DFPost+Book.h"
#import "DFPost+Comment.h"
#import "UIViewController+NavigationAround.h"
#import "DFTimeline.h"
#import "UIImage+Upload.h"
#import "DFPost+Upload.h"
#import "DFPhotoShowViewController.h"

#define TIMELINE_CELL_ID @"timeLineCellIdentifier"

@implementation DFTimeLineViewController {
    ACTimeScroller *_timeScroller;

    DFFooterView *_footerView;

    DFTimeline *_timeline;

    NSMutableArray *imageURLs;
}

- (id)init {
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;

        _timeline = [[DFTimeline alloc] init];
    }

    return self;
}

- (void)post {
    DFPostViewController *postVC = [[DFPostViewController alloc] init];
    postVC.delegate = self;

    [self presentViewController:[postVC aroundWithNavigation] animated:YES completion:nil];
}

- (void)loadView {
    [super loadView];

    self.tableView.separatorColor = [UIColor colorWithHexString:SEPARATOR_LINE_COLOR];
    self.tableView.allowsSelection = NO;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(pullForNew) forControlEvents:UIControlEventValueChanged];

    [self.tableView registerClass:[DFTimeLineCell class] forCellReuseIdentifier:TIMELINE_CELL_ID];

//    DFCoverView *coverView = [[DFCoverView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, COVER_VIEW_HEIGHT)];
//    self.tableView.tableHeaderView = coverView;

    _footerView = [[DFFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, FOOTER_VIEW_HEIGHT)];
    _footerView.delegate = self;
    self.tableView.tableFooterView = _footerView;

    self.view.backgroundColor = [UIColor whiteColor];

//    _timeScroller = [[ACTimeScroller alloc] initWithDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(0.0f, 0.0f, 34.0f, 34.0f);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];

    [self loadList];
}

#pragma mark - table view data source & delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFPost *post = [_timeline postAtIndex:(NSUInteger) indexPath.row];

    return [DFTimeLineCell heightForPost:post];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeline.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];
    cell.delegate = self;

    DFPost *post = [_timeline postAtIndex:(NSUInteger) indexPath.row];
    cell.post = post;

    return cell;
}

#pragma mark - Time Scroller Delegate

- (UITableView *)tableViewForTimeScroller:(ACTimeScroller *)timeScroller {
    return self.tableView;
}

- (NSDate *)timeScroller:(ACTimeScroller *)timeScroller dateForCell:(UITableViewCell *)cell {
    if (!cell)
        return [NSDate date];

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DFPost *post = [_timeline postAtIndex:(NSUInteger) indexPath.row];
    return post.publishDate;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];

    if (_timeline.count <= 0) {
        return;
    }

    if (_timeline.oldestPostID <= 1) {
        return;
    }

    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height + 10.0f) {
        if (!_footerView.isRefreshing) {
            [_footerView beginRefreshing];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidEndDecelerating];
}

#pragma mark - services

- (void)loadList {
    [_timeline loadList:^(long newPostCount) {
        [self.tableView reloadData];
        [self updateFooterViewText];

        [self showSuccessMessage:[NSString stringWithFormat:@"成功获取%ld条带饭信息", newPostCount]];
    }             error:^(NSError *error) {
        [self showErrorMessage:@"服务器出错了哦" description:@"BS做服务端的同学"];
    }          complete:^() {

    }];
}

- (void)pullForNew {
    [_timeline pullForNew:^(long newPostCount) {
        if (newPostCount == 0) {
            [self showWarningMessage:@"暂时没有新带饭信息了哦，亲"];
            return;
        }

        [self.tableView reloadData];

        [self showSuccessMessage:[NSString stringWithFormat:@"成功取得%ld条新带饭信息", newPostCount]];
    }               error:^(NSError *error) {
        [self showErrorMessage:@"服务器出错了哦" description:@"BS做服务端的同学"];
    }            complete:^() {
        [self.refreshControl endRefreshing];
        [self updateFooterViewText];
    }];
}

- (void)loadMore {
    [_timeline loadMore:^(long newPostCount) {
        [self.tableView reloadData];

        if (_timeline.oldestPostID == 1) {
            [self showSuccessMessage:@"WOW，成功获取到最古老的带饭信息了哦"];
        } else {
            [self showSuccessMessage:[NSString stringWithFormat:@"成功取得%ld条旧的带饭信息", newPostCount]];
        }
    }             error:^(NSError *error) {
        [self showErrorMessage:@"服务器出错了哦" description:@"BS做服务端的同学"];
    }          complete:^() {
        [_footerView endRefreshing];
        [self updateFooterViewText];
    }];
}

- (void)updateFooterViewText {
    if (_timeline.oldestPostID > 1) {
        [_footerView showHaveMore];
    } else {
        [_footerView showNoMore];
    }
}

#pragma mark - Book and Comment

- (void)bookOnPost:(DFPost *)aPost {
    [aPost bookOrUnbookByUser:_currentUser success:^(DFPost *post, BOOL booked) {
        [self.tableView reloadData];
        if (booked) {
            [self showSuccessMessage:@"抢饭成功哦"];
        } else {
            [self showSuccessMessage:@"退订成功"];
        }
    }                   error:^(NSError *error, BOOL book) {
        NSLog(@"book or unbook error: %@", error);
        if (book) {
            [self showErrorMessage:@"服务器出错，暂时不能订饭"];
        } else {
            [self showErrorMessage:@"服务器出错，暂时不能退订"];
        }
    }];
}

- (void)commentOnPost:(DFPost *)post {
    DFPostCommentViewController *vc = [[DFPostCommentViewController alloc] init];
    vc.post = post;
    vc.delegate = self;

    [self presentViewController:[vc aroundWithNavigation] animated:YES completion:nil];
}

#pragma Mark - post comment delegate

- (void)postComment:(NSString *)commentString toPost:(DFPost *)aPost {
    [aPost comment:commentString byUser:_currentUser success:^(DFPost *post) {
        [self.tableView reloadData];
        [self showSuccessMessage:@"成功发送评论"];
    }        error:^(NSError *error) {
        [self showErrorMessage:@"服务器出错，暂时不能发送评论"];
    }];
}

#pragma Mark - post delegate
- (void)post:(NSString *)postString images:(NSArray *)images date:(NSDate *)eatDate count:(NSInteger)totalCount {
    [self showEndlessInfoMessage:@"带饭信息发送中..."];

    __weak DFTimeLineViewController *weakSelf = self;

    DFPost *newPost = [[DFPost alloc] init];
    newPost.name = postString;
    newPost.eatDate = eatDate;
    newPost.count = totalCount;
    newPost.user = _currentUser;
    newPost.publishDate = [NSDate date];

    [newPost uploadWithImages:images success:^(DFPost *post) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf closeEndlessMessage];

            [_timeline addPost:post];
            NSLog(@"time line:%@", _timeline);

            [weakSelf.tableView reloadData];
            [weakSelf showSuccessMessage:@"带饭信息发送成功"];
        });
    }                   error:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf closeEndlessMessage];
            [weakSelf showErrorMessage:@"无法发送带饭信息"];
        });
    }];
}

#pragma mark - image show delegate

- (void)imageClickedForPost:(DFPost *)post index:(NSUInteger)index {
    DFPhotoShowViewController *vc = [[DFPhotoShowViewController alloc] initWithImages:post.images index:index];

    [self presentViewController:vc animated:YES completion:nil];
}


@end