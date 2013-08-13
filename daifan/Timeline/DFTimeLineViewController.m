#import "DFTimeLineViewController.h"
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "AFJSONRequestOperation.h"
#import "DFUserList.h"
#import "DFFooterView.h"
#import "DFUser.h"

#define TIMELINE_CELL_ID @"timeLineCellIdentifier"

@implementation DFTimeLineViewController {
    ACTimeScroller *_timeScroller;

    NSMutableArray *_posts;
    DFFooterView *_footerView;

    long _newestPostID;
    long _oldestPostID;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"51daifan";

        _posts = [[NSMutableArray alloc] init];

        _newestPostID = 0;
        _oldestPostID = LONG_MAX;
    }

    return self;
}

- (void)post {

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

    [self loadList];
}

#pragma mark - table view data source & delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFPost *post = [_posts objectAtIndex:(NSUInteger)indexPath.row];

    return [DFTimeLineCell heightForPost:post];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];
    cell.delegate = self;

    DFPost *post = [_posts objectAtIndex:(NSUInteger)indexPath.row];
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
    DFPost *post = [_posts objectAtIndex:(NSUInteger)indexPath.row];
    return post.publishDate;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];

    if (_posts.count <= 0) {
        return;
    }

    if (_oldestPostID <= 1) {
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

#pragma mark - Services

- (void)loadList {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POST_PATH, API_POST_NEW_LIST_PARAMETER];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"time line success.");
                NSDictionary *dict = (NSDictionary *)JSON;
                NSArray *posts = [ dict objectForKey:kRESPONSE_POSTS];

                NSDictionary *users = [dict objectForKey:kRESPONSE_BOOKED_USER_ID];
                [[DFUserList sharedList] mergeUserDict:users];

                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DFPost *post = [DFPost postFromDict:obj];
                    [self updateIDRange:post];
                    [_posts addObject:post];
                }];

                NSLog(@"time line count:%d.", _posts.count);

                [self.tableView reloadData];
                [self updateFooterViewText];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

- (void)pullForNew {
    NSString *newerListString = [NSString stringWithFormat:API_POST_NEWER_LIST_PARAMETER, _newestPostID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POST_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"time line newer success.");
                NSDictionary *dict = (NSDictionary *)JSON;
                NSArray *posts = [ dict objectForKey:kRESPONSE_POSTS];

                NSDictionary *users = [dict objectForKey:kRESPONSE_BOOKED_USER_ID];
                [[DFUserList sharedList] mergeUserDict:users];

                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    NSLog(@"%@", [DFPost postFromDict:obj]);
                    DFPost *post = [DFPost postFromDict:obj];
                    [self updateIDRange:post];
                    [_posts insertObject:post atIndex:idx];
                }];

                NSLog(@"time line count:%d.", _posts.count);

                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                [self updateFooterViewText];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

- (void)loadMore {
    NSString *newerListString = [NSString stringWithFormat:API_POST_OLDER_LIST_PARAMETER, _oldestPostID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POST_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"time line older success.");
                NSDictionary *dict = (NSDictionary *)JSON;
                NSArray *posts = [dict objectForKey:kRESPONSE_POSTS];

                NSDictionary *users = [dict objectForKey:kRESPONSE_BOOKED_USER_ID];
                [[DFUserList sharedList] mergeUserDict:users];

                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DFPost *post = [DFPost postFromDict:obj];
                    [self updateIDRange:post];
                    [_posts addObject:post];
                }];

                NSLog(@"time line count:%d.", _posts.count);

                [self.tableView reloadData];
                [_footerView endRefreshing];
                [self updateFooterViewText];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

- (void)updateIDRange:(DFPost *)post {
    if (post.identity > _newestPostID) {
        _newestPostID = post.identity;
    }

    if (post.identity < _oldestPostID) {
        _oldestPostID = post.identity;
    }
}

- (void)updateFooterViewText {
    NSLog(@"oldest id: %ld, newest id: %ld", _oldestPostID, _newestPostID);

    if (_oldestPostID > 1) {
        [_footerView showHaveMore];
    } else {
        [_footerView showNoMore];
    }
}

#pragma mark - Book and Comment

- (void)bookOnPost:(DFPost *)post {
    NSString *newerListString = [NSString stringWithFormat:API_BOOK_PARAMETER, post.identity, post.user.identity, post.user.name, _currentUser.identity, _currentUser.name];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_BOOK_PATH, newerListString];

    NSLog(@"request: %@", urlString);

    [post bookedByUser:_currentUser];

    [[DFUserList sharedList] mergeUserDict:@{@(_currentUser.identity).stringValue: _currentUser.name}];

    [self.tableView reloadData];

return;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"book success.");
                NSDictionary *dict = (NSDictionary *)JSON;

                if ([[dict objectForKey:kRESPONSE_SUCCESS] integerValue] == 1) {
                    [post bookedByUser:_currentUser];
                }

                [[DFUserList sharedList] mergeUserDict:@{@(_currentUser.identity).stringValue: _currentUser.name}];

                [self.tableView reloadData];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"book failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

- (void)commentOnPost:(DFPost *)post {

}


@end