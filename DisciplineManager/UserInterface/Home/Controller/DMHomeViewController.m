//
//  DMHomeViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMNavigationController.h"
#import "DMMainItemView.h"

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

@interface DMHomeViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *logoView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) DMMainItemView *todoView;
@property (nonatomic, strong) NSMutableArray<DMCmsContentModel *> *cmsContentList;

@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"app_name", @"纪管系统");
    [self createView];
    
    DMUserManager *manager = getManager([DMUserManager class]);
    [manager bindPush];
    DMPushManager *push = getManager([DMPushManager class]);
    __weak typeof(self) weakSelf = self;
    push.onNewMsgBlock = ^{
        [weakSelf onNewMsg];
    };
    
    [self loadCMSContent];
}

- (void)createView {
    NSMutableArray<__kindof UIView*> *childViews  = [[NSMutableArray alloc] init];
    [childViews addObject:self.logoView];
    
    //    [self.view addSubview:self.logoView];
    //
    //    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.view);
    //        make.top.equalTo(self.view);
    //        make.height.equalTo(@(SCREEN_WIDTH*0.618));
    //    }];
    CGFloat h = 0;
    for (NSInteger i=kMainItemTodo; i<1007; i++) {
        NSString *title;
        NSString *icon;
        switch (i) {
            case kMainItemTodo:
                title = NSLocalizedString(@"Todo",@"待办任务");
                icon = @"Todo";
                break;
            case kMainItemApplyOut:
                title = NSLocalizedString(@"ApplyOut",@"外出申请");
                icon = @"ApplyOut";
                break;
            case kMainItemApplyBus:
                title = NSLocalizedString(@"ApplyBus",@"公车申请");
                icon = @"ApplyBus";
                break;
            case kMainItemApplyCompensatory:
                title = NSLocalizedString(@"ApplyCompensatory",@"补休申请");
                icon = @"ApplyCompensatory";
                break;
            case kMainItemApplyLeave:
                title = NSLocalizedString(@"ApplyLeave",@"请假申请");
                icon = @"ApplyLeave";
                break;
            case kMainItemAddressBook:
                title = NSLocalizedString(@"AddressBook",@"通讯录");
                icon = @"AddressBook";
                break;
            default:
                title = NSLocalizedString(@"More",@"更多");
                icon = @"More";
                break;
        }
        
        DMMainItemView *mainItemView = [self getMainItemView:i title:title icon:icon];
        [mainItemView addTarget:self action:@selector(clickMainItemView:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger index = i-kMainItemTodo;
        CGFloat x = (index%3)*(mainItemView.width+0.5);
        CGFloat y = (index/3)*(mainItemView.height+0.5);
        mainItemView.frame = CGRectMake(x, y, mainItemView.width, mainItemView.height);
        if (i == kMainItemTodo) {
            self.todoView = mainItemView;
        }
        [self.contentView addSubview:mainItemView];
        h = y + mainItemView.height + 0.5;
    }
    self.contentView.lcHeight = h;
    [childViews addObject:self.contentView];
    
    [self setChildViews:childViews];
}

#pragma mark - getters and setters

- (SDCycleScrollView *)logoView {
    if (!_logoView) {
        NSArray *urls = @[/*[NSURL URLWithString:@"http://img2.imgtn.bdimg.com/it/u=1917120263,2189330565&fm=11&gp=0.jpg"],
                           [NSURL URLWithString:@"http://gbres.dfcfw.com/Files/picture/20140507/size500/024FDDE0195A318FC88E185936C1A24D.jpg"],
                           [NSURL URLWithString:@"http://i0.peopleurl.cn/nmsgimage/20150924/b_12511282_1443057242001.jpg"],
                           [NSURL URLWithString:@"http://i0.peopleurl.cn/nmsgimage/20150626/b_12511282_1435306319621.jpg"]*/];
        _logoView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.618) delegate:self placeholderImage:[UIImage imageNamed:@"HomeLogo"]];
        
        _logoView.infiniteLoop = YES;
        _logoView.autoScrollTimeInterval = 5;
        _logoView.imageURLStringsGroup = urls;
        _logoView.lcHeight = SCREEN_WIDTH*0.618;
    }
    return _logoView;
}

- (NSMutableArray<DMCmsContentModel *> *)cmsContentList {
    if (!_cmsContentList) {
        _cmsContentList = [[NSMutableArray<DMCmsContentModel *> alloc] init];
    }
    return _cmsContentList;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (DMMainItemView *)getMainItemView:(NSInteger)tag title:(NSString *)title icon:(NSString *)icon {
    DMMainItemView *mainItemView = [[DMMainItemView alloc] initWithIcon:icon];
    mainItemView.tag = tag;
    [mainItemView setTitleViewText:title];
    return mainItemView;
}

- (void)clickMainItemView:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case kMainItemTodo:
        {
            DMTodoViewController *controller = [[DMTodoViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [self.todoView hiddenDot:YES];
        }
            break;
        case kMainItemApplyOut:
        {
            DMApplyOutViewController *controller = [[DMApplyOutViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemApplyBus:
        {
            DMApplyBusViewController *controller = [[DMApplyBusViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemApplyCompensatory:
        {
            DMApplyCompensatoryController *controller = [DMApplyCompensatoryController alloc];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemApplyLeave:
        {
            DMApplyLeaveViewController *controller = [[DMApplyLeaveViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kMainItemAddressBook:
        {
            DMAddressBookViewController *controller = [[DMAddressBookViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
        {
            DMMoreViewController *controller = [[DMMoreViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }
}

- (void)onNewMsg {
    [self.todoView hiddenDot:NO];
}

#pragma mark - load data
- (void)loadCMSContent {
    [self.cmsContentList removeAllObjects];
    DMCmsContentRequster *requester = [[DMCmsContentRequster alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            [self.cmsContentList addObjectsFromArray:listModel.rows];
            
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
            for (DMCmsContentModel *mdl in self.cmsContentList) {
                [imagesURLStrings addObject:mdl.imgPath];
            }
            [self.logoView setImageURLStringsGroup:imagesURLStrings];
            self.logoView.delegate = self;
        }
    }];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //    DMCmsContentModel *mdl = [self.cmsContentList objectAtIndex:index];
    //    DMWebViewController *controller = [[DMWebViewController alloc] init];
    //    controller.hidesBottomBarWhenPushed = YES;
    //    controller.cmsModel = mdl;
    //    [self.navigationController pushViewController:controller animated:YES];
}

@end
