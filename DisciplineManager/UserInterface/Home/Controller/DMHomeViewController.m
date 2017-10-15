//
//  DMHomeViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMNavigationController.h"
#import "DMHomeHeadView.h"

#import "DMTodoViewController.h"
#import "DMApplyOutViewController.h"
#import "DMApplyBusViewController.h"
#import "DMApplyCompensatoryController.h"
#import "DMApplyLeaveViewController.h"
#import "DMAddressBookViewController.h"
#import "DMMoreViewController.h"
#import "SDCycleScrollView.h"
#import "DMUserManager.h"
#import "DMPushManager.h"
#import "DMCmsContentModel.h"
#import "DMCmsContentRequster.h"
#import "DMWebViewController.h"
#import "DMNewsCell.h"

#import "DMExhibitionViewController.h"
#import "DMRepastViewController.h"
#import "DMExhMostRequester.h"
#import "DMExhMostModel.h"
#import "MSSBrowseModel.h"
#import "MSSBrowseNetworkViewController.h"

#import "DMNoticeViewController.h"

@interface DMHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) DMHomeHeadView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray<DMCmsContentModel *> *cmsContentList;
@property (nonatomic, strong) NSMutableArray<DMExhMostModel *> *exhMostList;
@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = NSLocalizedString(@"app_name", @"纪管系统");
    //[self.navigationController setNavigationBarHidden:YES];
    [self createView];
    
    DMUserManager *manager = getManager([DMUserManager class]);
    [manager bindPush];
    DMPushManager *push = getManager([DMPushManager class]);
    __weak typeof(self) weakSelf = self;
    push.onNewMsgBlock = ^{
        [weakSelf onNewMsg];
    };
    
    [self loadExhMost];
    [self loadCMSContent:18];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if(!self.navigationController.navigationBar.hidden){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    NSUInteger childControllerCount = self.navigationController.viewControllers.count;
    if(childControllerCount > 1){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)createView {
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    //    [self.view addSubview:self.logoView];
    //
    //    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.view);
    //        make.top.equalTo(self.view);
    //        make.height.equalTo(@(SCREEN_WIDTH*0.618));
    //    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
}

#pragma mark - getters and setters
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor colorWithRGB:0xd9534f];
        if (IPHONEX) {
            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64+34);
//            _headView.lcHeight = 64+34;
//            _headView.lcTopMargin = -54;
        } else {
            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
//            _headView.lcHeight = 64;
//            _headView.lcTopMargin = -20;
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = NSLocalizedString(@"app_name", @"智慧行政");
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleView);
            if (IPHONEX) {
                make.centerY.equalTo(_titleView).offset(20);
            } else {
                make.centerY.equalTo(_titleView).offset(10);
            }
        }];
    }
    return _titleView;
}

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

- (DMHomeHeadView *)headView {
    if (!_headView) {
        _headView = [[DMHomeHeadView alloc] init];
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headView.height+3);
        __weak typeof(self) weakSelf = self;
        _headView.clickItemEvent = ^(NSInteger tag) {
            [weakSelf clickItemEvent:tag];
        };
        _headView.didSelectItemAtIndex = ^(NSInteger index) {
            [weakSelf didSelectItemAtIndex:index];
        };
    }
    return _headView;
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

- (NSMutableArray<DMExhMostModel *> *)exhMostList {
    if (!_exhMostList) {
        _exhMostList = [[NSMutableArray<DMExhMostModel *> alloc] init];
    }
    return _exhMostList;
}

- (void)clickItemEvent:(NSInteger)tag {
    switch (tag) {
        case kMainItemTodo:
        {
            DMTodoViewController *controller = [[DMTodoViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [self.headView.todoView hiddenDot:YES];
        }
            break;
        case kMainItemApplyOut:
        {
            DMApplyOutViewController *controller = [[DMApplyOutViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemTemporaryTask:
        {
            
        }
            break;
        case kMainItemExhibition:
        {
            DMExhibitionViewController *controller = [[DMExhibitionViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemApplyLeave:
        {
            DMApplyLeaveViewController *controller = [[DMApplyLeaveViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemApplyCompensatory:
        {
            DMApplyCompensatoryController *controller = [DMApplyCompensatoryController alloc];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemRepast:
        {
            DMRepastViewController *controller = [[DMRepastViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
        {
            DMNoticeViewController *controller = [[DMNoticeViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }
}

- (void)onNewMsg {
    [self.headView.todoView hiddenDot:NO];
}

#pragma mark - load data
- (void)loadExhMost {
    DMExhMostRequester *requester = [[DMExhMostRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            [self.exhMostList removeAllObjects];
            DMListBaseModel *listModel = data;
            [self.exhMostList addObjectsFromArray:listModel.rows];
            [self loadCMSContent:17];
        }
    }];
}
- (void)loadCMSContent:(NSInteger)channelId {
    if (channelId == 17) {
        [self.cmsContentList removeAllObjects];
    } else {
        [self.dataSource removeAllObjects];
    }
    
    DMCmsContentRequster *requester = [[DMCmsContentRequster alloc] init];
    requester.channelId = channelId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
            if (channelId == 17) {
                DMExhMostModel *exhModel = [self.exhMostList firstObject];
                if (exhModel) {
                    [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, exhModel.path]];
                }
            }
            for (DMCmsContentModel *mdl in listModel.rows) {
                if (channelId == 17) {
                    [imagesURLStrings addObject:mdl.imgPath];
                    [self.cmsContentList addObject:mdl];
                } else {
                    if (self.dataSource.count <= 3) {
                        [self.dataSource addObject:mdl];
                    } else {
                        break;
                    }
                }
            }
            if (channelId == 17) {
                [self.headView setImageURLStringsGroup:imagesURLStrings];
            } else {
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)didSelectItemAtIndex:(NSInteger)index {
    //    DMCmsContentModel *mdl = [self.cmsContentList objectAtIndex:index];
    //    DMWebViewController *controller = [[DMWebViewController alloc] init];
    //    controller.hidesBottomBarWhenPushed = YES;
    //    controller.cmsModel = mdl;
    //    [self.navigationController pushViewController:controller animated:YES];
    if (index == 0) {
        if (self.exhMostList.count > 0) {
            [self showImage];
        }
    }
}

- (void)showImage {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (DMExhMostModel *exhMostModel in self.exhMostList) {
        MSSBrowseModel *model = [[MSSBrowseModel alloc] init];
        model.bigImageUrl = [NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, exhMostModel.path];
        [imageArray addObject:model];
    }

    MSSBrowseNetworkViewController *controller = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:imageArray currentIndex:0];
    [controller showBrowseViewController];
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

@end
