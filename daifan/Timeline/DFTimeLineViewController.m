#import "DFTimeLineViewController.h"
#import "DFTimeLineView.h"
#import "DFCoverView.h"
#import "DFTimeLineCell.h"
#import "DFFooterView.h"
#import "DFPost.h"
#import "DFPostViewController.h"
#import "DFUser.h"
#import "AFJSONRequestOperation.h"

#define TIMELINE_CELL_ID @"timeLineCellIdentifier"

#define API_HOST @"http://51daifan.sinaapp.com/api"
#define API_POST_URL @"/posts"

#define API_POST_NEW_LIST_PARAMETER @"?type=0"
#define API_POST_NEWER_LIST_PARAMETER @"?type=1&currentId=%d"
#define API_POST_OLDER_LIST_PARAMETER @"?type=2&currentId=%d"

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

- (void)loadView {
    _timelineView = [[DFTimeLineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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

//    [self createFakePosts];
    [self loadList];
}

- (void)createFakePosts {
    DFUser *fakeUser = [[DFUser alloc] init];
    fakeUser.identity = 0;
    fakeUser.name = @"rong";
    fakeUser.avatarURLString = @"";

    for (int i = 0; i < 100; i++) {
        DFPost *fakePost = [[DFPost alloc] init];
        fakePost.identity = i;
        fakePost.publishDate = [NSDate dateWithTimeInterval:(i + 1) * -1000000.0f sinceDate:[NSDate date]];
        fakePost.description = @"带饭";
        fakePost.address = @"银科大厦";
        fakePost.user = fakeUser;

        [_posts addObject:fakePost];
    }
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", API_HOST, API_POST_URL, API_POST_NEW_LIST_PARAMETER];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSArray *posts = [(NSDictionary *) JSON objectForKey:@"posts"];

                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *postDict = obj;
                    DFPost *post = [[DFPost alloc] init];

                    post.identity = [[postDict objectForKey:@"objectId"] intValue];
                    post.address = [postDict objectForKey:@"address"];
                    post.name = [postDict objectForKey:@"name"];
                    post.description = [postDict objectForKey:@"describe"];

                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    post.publishDate = [dateFormatter dateFromString:[postDict objectForKey:@"createdAt"]];
                    NSLog(@"String: %@; Date: %@", [postDict objectForKey:@"createdAt"], post.publishDate);

                    DFUser *user = [[DFUser alloc] init];
                    user.identity = [[postDict objectForKey:@"user"] intValue];
                    user.name = [postDict objectForKey:@"realName"];
                    user.avatarURLString = [postDict objectForKey:@"avatarThumbnail"];
                    post.user = user;

                    [_posts addObject:post];

                    [_timelineView reloadData];
                }];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            }];
    [operation start];
}

@end