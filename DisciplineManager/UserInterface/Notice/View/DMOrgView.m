//
//  DMOrgView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMOrgView.h"
#import "DMSearchOrgRequester.h"
#import "DMOrgModel.h"
#import "DMOrgCell.h"

@interface DMOrgView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DMOrgView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self loadNewData];
    }
    return self;
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRGB:0xf0f0f0];
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_org";
    DMOrgCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMOrgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    //cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRGB:0xffffff];
    cell.orgInfo = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.onSelectOrgBlock) {
        DMOrgModel *orgInfo = [self.dataSource objectAtIndex:indexPath.row];
        self.onSelectOrgBlock(orgInfo);
    }
}

#pragma mark - loaddata
- (void)loadNewData {
    DMSearchOrgRequester *requester = [[DMSearchOrgRequester alloc] init];
    //    requester.limit = kPageSize;
    //    requester.offset = self.currentPage;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            NSMutableArray<DMOrgModel*> *list = listModel.rows;
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:list];
            if (listModel.total > self.dataSource.count) {
                self.tableView.mj_footer.hidden = NO;
            } else {
                self.tableView.mj_footer.hidden = YES;
            }
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            if (self.onSelectOrgBlock) {
                DMOrgModel *orgInfo = [self.dataSource objectAtIndex:0];
                self.onSelectOrgBlock(orgInfo);
            }
        }
    }];
}

@end
