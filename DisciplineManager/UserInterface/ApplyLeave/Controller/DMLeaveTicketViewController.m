//
//  DMLeaveTicketViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLeaveTicketViewController.h"
#import "DMLeaveTicketRequester.h"
#import "DMLeaveTicketModel.h"
#import "DMLeaveTicketCell.h"

@interface DMLeaveTicketViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation DMLeaveTicketViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isProvideSelect = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"MyLeaveTicket", @"我的休假票");
    
    if (self.isProvideSelect) {
        [self addNavRightItem:@selector(clickSure) andTitle:NSLocalizedString(@"sure",@"确定")];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)clickSure {
    NSMutableArray *selectedData = [[NSMutableArray alloc] init];
    for (DMLeaveTicketModel *model in self.dataSource) {
        if (model.selected) {
            [selectedData addObject:model];
        }
    }
    if (selectedData.count > 0) {
        if (self.selectedLeaveTicketBlock) {
            self.selectedLeaveTicketBlock(selectedData);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        showToast(@"请选择休假票");
    }
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_LeaveTicket";
    DMLeaveTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMLeaveTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.isProvideSelect = self.isProvideSelect;
    cell.leaveTicketModel = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isProvideSelect) {
        DMLeaveTicketCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        DMLeaveTicketModel *leaveTicketModel = [self.dataSource objectAtIndex:indexPath.row];
        leaveTicketModel.selected = !leaveTicketModel.selected;
        if (cell.leaveTicketModel.ltId == leaveTicketModel.ltId) {
            [cell selectedTicket];
        }
    }
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
    DMLeaveTicketRequester *requester = [[DMLeaveTicketRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMLeaveTicketModel*> *list = listModel.rows;
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
    DMLeaveTicketRequester *requester = [[DMLeaveTicketRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage+1;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_footer endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMLeaveTicketModel*> *list = listModel.rows;
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
