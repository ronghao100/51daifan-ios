#import "DFTimeLineViewController.h"
#import "DFTimeLineView.h"
#import "DFCoverView.h"
#import "DFTimeLineCell.h"
#import "DFFooterView.h"
#import "DFPost.h"
#import "DFPostViewController.h"
#import "DFUser.h"
#import "AFJSONRequestOperation.h"
#import "DFUserList.h"

#define TIMELINE_CELL_ID @"timeLineCellIdentifier"

@implementation DFTimeLineViewController {
    DFTimeLineView *_timelineView;
    ACTimeScroller *_timeScroller;

    NSMutableArray *_posts;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"51带饭";

        _posts = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)post {

}

- (void)loadView {
    _timelineView = [[DFTimeLineView alloc] initWithFrame:[UIScreen mainScreen].applicationBounds];
    _timelineView.delegate = self;
    _timelineView.dataSource = self;
    _timelineView.separatorColor = [UIColor orangeColor];

    [_timelineView registerClass:[DFTimeLineCell class] forCellReuseIdentifier:TIMELINE_CELL_ID];

    DFCoverView *coverView = [[DFCoverView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, COVER_VIEW_HEIGHT)];
    _timelineView.tableHeaderView = coverView;

    DFFooterView *footerView = [[DFFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, FOOTER_VIEW_HEIGHT)];
    _timelineView.tableFooterView = footerView;

    self.view = _timelineView;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];

    _timeScroller = [[ACTimeScroller alloc] initWithDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(5.0f, 5.0f, 34.0f, 34.0f);

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DFPostViewController *postVC = [[DFPostViewController alloc] initWithPost:[_posts objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:postVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Time Scroller Delegate

- (UITableView *)tableViewForTimeScroller:(ACTimeScroller *)timeScroller {
    return _timelineView;
}

- (NSDate *)timeScroller:(ACTimeScroller *)timeScroller dateForCell:(UITableViewCell *)cell {
    if (!cell)
        return [NSDate date];

    NSIndexPath *indexPath = [_timelineView indexPathForCell:cell];
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
                    [_posts addObject:[DFPost postFromDict:obj]];
                }];

                [_timelineView reloadData];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"time line failed. \n response: %@, error: %@, JSON: %@", response, error, JSON);
            }];
    [operation start];
}

@end