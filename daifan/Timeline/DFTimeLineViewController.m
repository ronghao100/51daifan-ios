#import "DFTimeLineViewController.h"
#import "DFTimeLineCell.h"
#import "DFPost.h"
#import "AFJSONRequestOperation.h"
#import "DFUserList.h"

#define TIMELINE_CELL_ID @"timeLineCellIdentifier"

@implementation DFTimeLineViewController {
    ACTimeScroller *_timeScroller;

    NSMutableArray *_posts;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"51daifan";

        _posts = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)post {

}

- (void)loadView {
    [super loadView];

    _timelineView.separatorColor = [UIColor colorWithHexString:SEPARATOR_LINE_COLOR];
    self.tableView.allowsSelection = NO;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(pullForNew) forControlEvents:UIControlEventValueChanged];

    [self.tableView registerClass:[DFTimeLineCell class] forCellReuseIdentifier:TIMELINE_CELL_ID];

//    DFCoverView *coverView = [[DFCoverView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, COVER_VIEW_HEIGHT)];
//    _timelineView.tableHeaderView = coverView;

//    DFFooterView *footerView = [[DFFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, FOOTER_VIEW_HEIGHT)];
//    _timelineView.tableFooterView = footerView;

    self.view.backgroundColor = [UIColor whiteColor];

    _timeScroller = [[ACTimeScroller alloc] initWithDelegate:self];
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
    DFPost *post = [_posts objectAtIndex:indexPath.row];

    return [DFTimeLineCell heightForPost:post];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];

    DFPost *post = [_posts objectAtIndex:indexPath.row];
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
    DFPost *post = [_posts objectAtIndex:indexPath.row];
    return post.publishDate;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];
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
//                    NSLog(@"%@", [DFPost postFromDict:obj]);
                    [_posts addObject:[DFPost postFromDict:obj]];
                }];

                NSLog(@"time line count:%d.", _posts.count);

                [self.tableView reloadData];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

- (void)pullForNew {
    NSString *newerListString = [NSString stringWithFormat:API_POST_NEWER_LIST_PARAMETER, ((DFPost *)_posts[0]).identity];
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
                    [_posts insertObject:[DFPost postFromDict:obj] atIndex:idx];
                }];

                NSLog(@"time line count:%d.", _posts.count);

                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

@end