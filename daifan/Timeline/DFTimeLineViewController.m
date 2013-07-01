#import "DFTimeLineViewController.h"
#import "DFTimeLineView.h"
#import "DFCoverView.h"
#import "DFTimeLineCell.h"

#define COVER_VIEW_HEIGHT 100.0f


@implementation DFTimeLineViewController {

}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Daifan";
    }

    return self;
}

- (void)loadView {
    DFTimeLineView *timelineView = [[DFTimeLineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    timelineView.delegate = self;
    timelineView.dataSource = self;

    DFCoverView *coverView = [[DFCoverView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, timelineView.frame.size.width, COVER_VIEW_HEIGHT)];
    coverView.backgroundColor = [UIColor orangeColor];

    timelineView.tableHeaderView = coverView;

    self.view = timelineView;
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"timeLineCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[DFTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = @"fan";

    return cell;
}






@end