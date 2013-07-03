#import "DFTimeLineViewController.h"
#import "DFTimeLineView.h"
#import "DFCoverView.h"
#import "DFTimeLineCell.h"
#import "DFFooterView.h"
#import "ACTimeScroller.h"

#define TIMELINE_CELL_ID @"timeLineCellIdentifier"

@implementation DFTimeLineViewController {
    DFTimeLineView *_timelineView;
    ACTimeScroller *_timeScroller;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"51带饭";
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

#pragma mark - table view data source & delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f + (indexPath.row % 10) * 10.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];

    cell.textLabel.text = @"饭";

    return cell;
}

#pragma mark - Time Scroller Delegate

- (UITableView *)tableViewForTimeScroller:(ACTimeScroller *)timeScroller {
    return _timelineView;
}

- (NSDate *)timeScroller:(ACTimeScroller *)timeScroller dateForCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [_timelineView indexPathForCell:cell];
    return [NSDate dateWithTimeInterval:indexPath.row * 10000.0f sinceDate:[NSDate date]];
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