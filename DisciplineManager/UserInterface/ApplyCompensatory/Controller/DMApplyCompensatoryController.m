//
//  DMApplyCompensatoryController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMApplyCompensatoryController.h"
#import "DMFillinApplyCompensatoryController.h"
#import "DMApplyOutCell.h"
#import "DMDetailApplyCompensatoryController.h"
#import "DMSearchApplyCompensatoryRequester.h"

@interface DMApplyCompensatoryController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DMApplyCompensatoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"ApplyCompensatory",@"补休申请");
    
    [self addNavRightItem:@selector(clickApply) andTitle:NSLocalizedString(@"Apply",@"申请")];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setRefreshView];
}

#pragma mark - event method
- (void)clickApply {
    DMFillinApplyCompensatoryController *controller = [[DMFillinApplyCompensatoryController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    return [DMApplyOutCell getFormHeight:[self.dataSource objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_ApplyCompensatory";
    DMApplyOutCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMApplyOutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.info = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMDetailApplyCompensatoryController *controller = [[DMDetailApplyCompensatoryController alloc] init];
    DMApplyOutListInfo *info = [self.dataSource objectAtIndex:indexPath.row];
    controller.acId = info.formId;
    [self.navigationController pushViewController:controller animated:YES];
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
    DMSearchApplyCompensatoryRequester *requester = [[DMSearchApplyCompensatoryRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMApplyCompensatoryListInfo *> *list = listModel.rows;
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
    DMSearchApplyCompensatoryRequester *requester = [[DMSearchApplyCompensatoryRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = (self.currentPage+1)*kPageSize;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMApplyCompensatoryListInfo *> *list = listModel.rows;
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
