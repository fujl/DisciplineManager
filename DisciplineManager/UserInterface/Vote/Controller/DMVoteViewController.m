//
//  DMVoteViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/9/12.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteViewController.h"
#import "DMPublishVoteViewController.h"
#import "DMVoteListCell.h"
#import "DMSearchVoteRequester.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DMVoteDetailController.h"

@interface DMVoteViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DMVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"vote",@"投票");
    
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"发布")];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setRefreshView];
}

#pragma mark - event method
- (void)clickPublish {
    DMPublishVoteViewController *controller = [[DMPublishVoteViewController alloc] init];
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
        [_tableView registerClass:[DMVoteListCell class] forCellReuseIdentifier:@"dequeueReusableCell_VoteList"];
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
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"dequeueReusableCell_VoteList" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_VoteList";
    DMVoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMVoteListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMVoteDetailController *controller = [[DMVoteDetailController alloc] init];
    DMVoteListInfo *info = [self.dataSource objectAtIndex:indexPath.row];
    controller.vlId = info.vlId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)configureCell:(DMVoteListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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
    DMSearchVoteRequester *requester = [[DMSearchVoteRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = self.currentPage;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMVoteListInfo*> *list = listModel.rows;
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
    DMSearchVoteRequester *requester = [[DMSearchVoteRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = (self.currentPage+1)*kPageSize;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMVoteListInfo*> *list = listModel.rows;
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
