//
//  DMNoticeViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticeViewController.h"
#import "DMNoticePublishController.h"
#import "DMNoticeHeadView.h"
#import "DMNoticeCell.h"
#import "DMSearchNoticeRequester.h"
#import "DMNoticeDetailController.h"

@interface DMNoticeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DMNoticeHeadView *headView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DMNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"notice", @"通知公告");
    
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"")];
    
    [self.view addSubview:self.headView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    self.headView.type = NoticeTypeUnread;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setRefreshView];
}

- (void)clickPublish {
    DMNoticePublishController *controller = [[DMNoticePublishController alloc] init];
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

- (DMNoticeHeadView *)headView {
    if (!_headView) {
        _headView = [[DMNoticeHeadView alloc] init];
        __weak typeof(self) weakSelf = self;
        _headView.onSelectNoticeType = ^{
            [weakSelf onSelectType];
        };
    }
    return _headView;
}

- (void)onSelectType {
    [self setRefreshView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_NoticeCell";
    DMNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.noticeInfo = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMNoticeDetailController *controller = [[DMNoticeDetailController alloc] init];
    DMNoticeInfo *info = [self.dataSource objectAtIndex:indexPath.row];
    controller.noticeInfo = info;
    if (self.headView.type == NoticeTypeUnread) {
        controller.isReadSign = NO;
    } else {
        controller.isReadSign = YES;
    }
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
    DMSearchNoticeRequester *requester = [[DMSearchNoticeRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage;
    if (self.headView.type != NoticeTypeMine) {
        requester.isReadSign = self.headView.type == NoticeTypeUnread ? 0 : 1;
    } else {
        DMUserManager *manager = getManager([DMUserManager class]);
        requester.userId = manager.loginInfo.userId;
        requester.isReadSign = -1;
    }
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMNoticeInfo*> *list = listModel.rows;
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
    DMSearchNoticeRequester *requester = [[DMSearchNoticeRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = (self.currentPage+1)*kPageSize;
    if (self.headView.type != NoticeTypeMine) {
        requester.isReadSign = self.headView.type == NoticeTypeUnread ? 0 : 1;
    } else {
        DMUserManager *manager = getManager([DMUserManager class]);
        requester.userId = manager.loginInfo.userId;
        requester.isReadSign = -1;
    }
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMNoticeInfo*> *list = listModel.rows;
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
