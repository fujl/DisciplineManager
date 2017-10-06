//
//  DMVoteViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/9/12.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNewsViewController.h"
#import "DMWebViewController.h"
#import "DMNewsCell.h"
#import "DMCmsContentRequster.h"

@interface DMNewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray<DMCmsContentModel *> *cmsContentList;
@end

@implementation DMNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"news",@"简讯");
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    [self loadCMSContent];
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

- (NSMutableArray<DMCmsContentModel *> *)cmsContentList {
    if (!_cmsContentList) {
        _cmsContentList = [[NSMutableArray<DMCmsContentModel *> alloc] init];
    }
    return _cmsContentList;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellName = @"dequeueReusableCell_OnlinePatientCell";
    DMNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellName];
    if (!cell) {
        cell = [[DMNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.newsInfoModel = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMCmsContentModel *mdl = [self.dataSource objectAtIndex:indexPath.row];
    DMWebViewController *controller = [[DMWebViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.cmsModel = mdl;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - load data
- (void)loadCMSContent {
    [self.cmsContentList removeAllObjects];
    DMCmsContentRequster *requester = [[DMCmsContentRequster alloc] init];
    requester.channelId = 18;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            [self.cmsContentList addObjectsFromArray:listModel.rows];
            
            [self.dataSource removeAllObjects];
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
            for (DMCmsContentModel *mdl in self.cmsContentList) {
                [imagesURLStrings addObject:mdl.imgPath];
                if (mdl.ccId != 14) {
                    [self.dataSource addObject:mdl];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

@end
