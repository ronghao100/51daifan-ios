#import "DFTimeLineViewController.h"
#import "DFTimeLineView.h"
#import "DFCoverView.h"
#import "DFTimeLineCell.h"
#import "DFFooterView.h"
#import "DFPost.h"
#import "DFPostViewController.h"
#import "DFUser.h"

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

        [self createFakePosts];
    }

    return self;
}

- (void)loadView {
    _timelineView = [[DFTimeLineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _timelineView.delegate = self;
    _timelineView.dataSource = self;

    [_timelineView registerClass:[DFTimeLineCell class] forCellReuseIdentifier:TIMELINE_CELL_ID];

    DFCoverView *coverView = [[DFCoverView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, COVER_VIEW_HEIGHT)];
    coverView.backgroundColor = [UIColor orangeColor];
    _timelineView.tableHeaderView = coverView;

    DFFooterView *footerView = [[DFFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _timelineView.frame.size.width, FOOTER_VIEW_HEIGHT)];
    _timelineView.tableFooterView = footerView;

    self.view = _timelineView;
    self.view.backgroundColor = [UIColor lightGrayColor];

    _timeScroller = [[ACTimeScroller alloc] initWithDelegate:self];
}

- (void)createFakePosts {
    DFUser *fakeUser = [[DFUser alloc] init];
    fakeUser.id = 0;
    fakeUser.name = @"rong";
    fakeUser.avatarURLString = @"";

    for (int i = 0; i < 100; i ++) {
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
    return 50.0f + (indexPath.row % 10) * 10.0f;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewDidEndDecelerating];
}


@end