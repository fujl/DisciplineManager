//
//  DMReceiverView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMReceiverView.h"
#import "DMReceiverCell.h"
#import "DMSearchUserRequester.h"

@interface DMReceiverView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DMReceiverView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
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

- (NSMutableDictionary *)selectedUserDictionary {
    if (!_selectedUserDictionary) {
        _selectedUserDictionary = [[NSMutableDictionary alloc] init];
    }
    return _selectedUserDictionary;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)setOrgInfo:(DMOrgModel *)orgInfo {
    _orgInfo = orgInfo;
    [self setRefreshView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_UserBook";
    DMReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMReceiverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    DMUserBookModel *user = [self.dataSource objectAtIndex:indexPath.row];
    cell.userInfo = user;
    DMUserBookModel *selectedUser = [self.selectedUserDictionary objectForKey:user.userId];
    if (selectedUser) {
        cell.selectedUser = YES;
    } else {
        cell.selectedUser = NO;
    }
    __weak typeof(self) weakSelf = self;
    cell.onSelectUserBlock = ^(DMUserBookModel *user, BOOL selectedUser) {
        [weakSelf selectUser:user selectedUser:selectedUser];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    DMSearchUserRequester *requester = [[DMSearchUserRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage;
    requester.orgId = self.orgInfo.code;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMUserBookModel*> *list = listModel.rows;
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
    DMSearchUserRequester *requester = [[DMSearchUserRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage+1;
    requester.orgId = self.orgInfo.code;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMUserBookModel*> *list = listModel.rows;
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

#pragma mark - selected data
- (void)selectUser:(DMUserBookModel *)user selectedUser:(BOOL)selectedUser {
    DMUserBookModel *mdl = [self.selectedUserDictionary objectForKey:user.userId];
    if (mdl) {
        if (!selectedUser) {
            [self.selectedUserDictionary removeObjectForKey:user.userId];
        }
    } else {
        if (selectedUser) {
            [self.selectedUserDictionary setObject:user forKey:user.userId];
        }
    }
}

@end
