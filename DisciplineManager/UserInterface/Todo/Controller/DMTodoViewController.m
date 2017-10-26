//
//  DMTodoViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTodoViewController.h"
#import "DMActivitiTaskRequester.h"
#import "DMTodoCell.h"
#import "DMActivitiTaskModel.h"
#import "DMDetailApplyLeaveController.h"
#import "DMDetailApplyBusController.h"
#import "DMDetailApplyOutController.h"
#import "DMDetailApplyCompensatoryController.h"
#import "DMSuperviseDetailController.h"

@interface DMTodoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DMTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Todo",@"待办任务");
    
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_TodoCell";
    DMTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMTodoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.activitiTaskModel = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMActivitiTaskModel *mdl = [self.dataSource objectAtIndex:indexPath.row];
    if ([self qjsq:mdl.definitionKey]) {
        [self gotoQJSQDetail:mdl];
    } else if([mdl.definitionKey isEqualToString:kDefinitionKeyGCSQ_SJLD] || [mdl.definitionKey isEqualToString:kDefinitionKeyGCSQ_BGSSP] || [mdl.definitionKey isEqualToString:kDefinitionKeyGCSQ_JSY]) {
        [self gotoGCSQDetail:mdl];
    } else if ([self wcsq:mdl.definitionKey]) {
        [self gotoWCSQDetail:mdl];
    } else if ([self bxp:mdl.definitionKey]) {
        [self gotoBXPDetail:mdl];
    } else if ([mdl.definitionKey isEqualToString:kDefinitionKeyDBRW_BLRW]
               || [mdl.definitionKey isEqualToString:kDefinitionKeyDBRW_BLZPRW]) {
        [self gotoSuperviseDetail:mdl];
    }
}

// 请假申请条件
- (BOOL)qjsq:(NSString *)definitionKey {
    return [definitionKey isEqualToString:kDefinitionKeyQJSQ_BMLD]
    || [definitionKey isEqualToString:kDefinitionKeyQJSQ_FGLD]
    || [definitionKey isEqualToString:kDefinitionKeyQJSQ_TJLD]
    || [definitionKey isEqualToString:kDefinitionKeyQJSQ_TJFGLD];
}

// 外出申请条件
- (BOOL)wcsq:(NSString *)definitionKey {
    return [definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD]
    || [definitionKey isEqualToString:kDefinitionKeyWCSQ_TJLD]
    || [definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP]
    || [definitionKey isEqualToString:kDefinitionKeyWCSQ_JSY]
    || [definitionKey isEqualToString:kDefinitionKeyWCSQ_WCHG];
}

- (BOOL)bxp:(NSString *)definitionKey {
    return [definitionKey isEqualToString:kDefinitionKeyBXP_BMLD]
    || [definitionKey isEqualToString:kDefinitionKeyBXP_FGLD]
    || [definitionKey isEqualToString:kDefinitionKeyBXP_TJLD]
    || [definitionKey isEqualToString:kDefinitionKeyBXP_RSK];
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
    DMActivitiTaskRequester *requester = [[DMActivitiTaskRequester alloc] init];
    requester.limit = kPageSize*2;
    requester.offset = self.currentPage;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_header endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage = 0;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMActivitiTaskModel*> *list = listModel.rows;
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
    DMActivitiTaskRequester *requester = [[DMActivitiTaskRequester alloc] init];
    requester.limit = kPageSize*2;
    requester.offset = (self.currentPage+1)*kPageSize*2;
    [requester postRequest:^(DMResultCode code, id data) {
        [self.tableView.mj_footer endRefreshing];
        if (code == ResultCodeOK) {
            self.currentPage++;
            DMListBaseModel *listModel = data;
            NSMutableArray<DMActivitiTaskModel*> *list = listModel.rows;
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

#pragma mark - GOTO Detail
- (void)gotoQJSQDetail:(DMActivitiTaskModel *)model {
    DMDetailApplyLeaveController *controller = [[DMDetailApplyLeaveController alloc] init];
    controller.alId = model.businessId;
    controller.activitiTaskModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoGCSQDetail:(DMActivitiTaskModel *)model {
    DMDetailApplyBusController *controller = [[DMDetailApplyBusController alloc] init];
    controller.abId = model.businessId;
    controller.activitiTaskModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoWCSQDetail:(DMActivitiTaskModel *)model {
    DMDetailApplyOutController *controller = [[DMDetailApplyOutController alloc] init];
    controller.aoId = model.businessId;
    controller.activitiTaskModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoBXPDetail:(DMActivitiTaskModel *)model {
    DMDetailApplyCompensatoryController *controller = [[DMDetailApplyCompensatoryController alloc] init];
    controller.acId = model.businessId;
    controller.activitiTaskModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoSuperviseDetail:(DMActivitiTaskModel *)model {
    DMSuperviseDetailController *controller = [[DMSuperviseDetailController alloc] init];
    controller.slId = model.businessId;
    controller.activitiTaskModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
