//
//  DMExhibitionViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhibitionViewController.h"
#import "DMExhibitionPublishController.h"
#import "DMExhibitionCell.h"
#import "DMExhListModel.h"
#import "DMSearchExhRequester.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface DMExhibitionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DMExhibitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"exhibition", @"");
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"")];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)clickPublish {
    DMExhibitionPublishController *controller = [[DMExhibitionPublishController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setRefreshView];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DMExhibitionCell class] forCellReuseIdentifier:@"dequeueReusableCell_ExhibitionCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [DMApplyOutCell getFormHeight:[self.dataSource objectAtIndex:indexPath.row]];
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"dequeueReusableCell_ExhibitionCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_ExhibitionCell";
    DMExhibitionCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMExhibitionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DMDetailApplyLeaveController *controller = [[DMDetailApplyLeaveController alloc] init];
//    DMApplyLeaveListInfo *info = [self.dataSource objectAtIndex:indexPath.row];
//    controller.alId = info.formId;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)configureCell:(DMExhibitionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.info = [self.dataSource objectAtIndex:indexPath.row];
}

#pragma mark - load data
- (void)setRefreshView {
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadNewData {
    self.currentPage = 0;
    DMSearchExhRequester *requester = [[DMSearchExhRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMExhListModel*> *list = listModel.rows;
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:list];
            if (listModel.total > self.dataSource.count) {
                self.tableView.mj_footer.hidden = NO;
            } else {
                self.tableView.mj_footer.hidden = YES;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData {
    DMSearchExhRequester *requester = [[DMSearchExhRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = (self.currentPage+1)*kPageSize;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMExhListModel*> *list = listModel.rows;
            [self.dataSource addObjectsFromArray:list];
            if (listModel.total > self.dataSource.count) {
                self.tableView.mj_footer.hidden = NO;
            } else {
                self.tableView.mj_footer.hidden = YES;
            }
            [self.tableView reloadData];
        }
    }];
}

@end
