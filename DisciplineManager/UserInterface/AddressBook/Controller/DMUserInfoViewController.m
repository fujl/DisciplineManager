//
//  DMUserInfoViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserInfoViewController.h"
#import "DMUserInfoHeadView.h"
#import "DMSelectItemView.h"

@interface DMUserInfoViewController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMUserInfoHeadView *headView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSelectItemView *phoneView;
@property (nonatomic, strong) DMSingleView *deptView;
@property (nonatomic, strong) DMSingleView *leaderView;
@property (nonatomic, strong) DMSingleView *emailView;
@property (nonatomic, strong) DMSingleView *addressView;
@property (nonatomic, strong) DMSingleView *detailView;
@property (nonatomic, strong) DMSingleView *reasonView;
@property (nonatomic, strong) DMSingleView *timeView;

@end

@implementation DMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.userInfo.name;
    
    [self loadData];
    [self loadSubview];
}

- (void)loadData {
    self.headView.userInfo = self.userInfo;
    [self.stateView setTitle:@"状态" detail:@""];
    [self refreshState];
    [self.phoneView setTitle:@"手机号"];
    [self.phoneView hiddenArrow];
    [self.phoneView setValue:self.userInfo.mobile];
    [self.deptView setTitle:@"所属部门" detail:self.userInfo.orgName];
    [self.leaderView setTitle:@"部门领导" detail:self.userInfo.deptUserName];
    [self.emailView setTitle:@"电子邮箱" detail:self.userInfo.email];
    [self.addressView setTitle:@"地区" detail:[NSString stringWithFormat:@"%@%@%@", self.userInfo.province, self.userInfo.city, self.userInfo.county]];
    [self.detailView setTitle:@"详细地址" detail:self.userInfo.address];
    
    if (![self.userInfo.reason isEqualToString:@""] && ![self.userInfo.startTime isEqualToString:@""]) {
        // 外出
        [self.reasonView setTitle:@"外出事由" detail:self.userInfo.reason];
        [self.timeView setTitle:@"外出时间" detail:self.userInfo.startTime];
    } else if (![self.userInfo.leaveReason isEqualToString:@""] && ![self.userInfo.leaveTime isEqualToString:@""]) {
        if(self.userInfo.leaveType == 0) {
            // 请假
            [self.reasonView setTitle:@"请假事由" detail:self.userInfo.leaveReason];
            [self.timeView setTitle:@"请假时间" detail:self.userInfo.leaveTime];
        } else if(self.userInfo.leaveType == 1) {
            // 休假
            [self.reasonView setTitle:@"休假事由" detail:self.userInfo.leaveReason];
            [self.timeView setTitle:@"休假时间" detail:self.userInfo.leaveTime];
        }
    }
}

- (void)refreshState {
    self.stateView.detailLabel.textColor = [UIColor whiteColor];
    self.stateView.detailLabel.text = [self.userInfo getStateString];
    self.stateView.detailLabel.backgroundColor = [self.userInfo getStateColor];
//    BOOL isOut = self.userInfo.goOutState > 0;
//    if (isOut) {
//        self.stateView.detailLabel.text = NSLocalizedString(@"Out", @"外出");
//        self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
//    } else if (self.userInfo.leaveState2 > 0) {
//        self.stateView.detailLabel.text = NSLocalizedString(@"Vacation", @"休假");
//        self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0xd9534f];
//    } else if (self.userInfo.leaveState > 0) {
//        self.stateView.detailLabel.text = NSLocalizedString(@"Leave", @"请假");
//        self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
//    } else {
//        self.stateView.detailLabel.text = NSLocalizedString(@"OnGuard", @"在岗");
//        self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
//    }
    [self.stateView refreshSize:CGSizeMake(50, 30)];
    self.stateView.detailLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)loadSubview {
    [self.subviewList removeAllObjects];
    
    [self.subviewList addObject:self.headView];
    [self.subviewList addObject:self.stateView];
    [self.subviewList addObject:self.phoneView];
    [self.subviewList addObject:self.deptView];
    [self.subviewList addObject:self.leaderView];
    [self.subviewList addObject:self.emailView];
    [self.subviewList addObject:self.addressView];
    [self.subviewList addObject:self.detailView];
    if (![self.userInfo.reason isEqualToString:@""] && ![self.userInfo.startTime isEqualToString:@""]) {
        // 外出
        [self.subviewList addObject:self.reasonView];
        [self.subviewList addObject:self.timeView];
    } else if (![self.userInfo.leaveReason isEqualToString:@""] && ![self.userInfo.leaveTime isEqualToString:@""]) {
        if(self.userInfo.leaveType == 0) {
            // 请假
            [self.subviewList addObject:self.reasonView];
            [self.subviewList addObject:self.timeView];
        } else if(self.userInfo.leaveType == 1) {
            // 休假
            [self.subviewList addObject:self.reasonView];
            [self.subviewList addObject:self.timeView];
        }
    }
    [self setChildViews:self.subviewList];
}


- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMUserInfoHeadView *)headView {
    if (!_headView) {
        _headView = [[DMUserInfoHeadView alloc] init];
    }
    return _headView;
}

- (DMSingleView *)stateView {
    if (!_stateView) {
        _stateView = [[DMSingleView alloc] init];
        _stateView.detailLabel.layer.masksToBounds = YES;
        _stateView.detailLabel.layer.cornerRadius = 3;
        _stateView.lcHeight = 44;
    }
    return _stateView;
}

- (DMSelectItemView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[DMSelectItemView alloc] init];
        _phoneView.title = NSLocalizedString(@"vote_type", @"投票类型");
        _phoneView.value = NSLocalizedString(@"radio", @"单选");
        _phoneView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _phoneView.clickEntryBlock = ^(NSString *value) {
            [weakSelf callPhone:weakSelf.userInfo];
        };
    }
    return _phoneView;
}

- (DMSingleView *)deptView {
    if (!_deptView) {
        _deptView = [[DMSingleView alloc] init];
        _deptView.lcHeight = 44;
    }
    return _deptView;
}

- (DMSingleView *)leaderView {
    if (!_leaderView) {
        _leaderView = [[DMSingleView alloc] init];
        _leaderView.lcHeight = 44;
    }
    return _leaderView;
}

- (DMSingleView *)emailView {
    if (!_emailView) {
        _emailView = [[DMSingleView alloc] init];
        _emailView.lcHeight = 44;
    }
    return _emailView;
}

- (DMSingleView *)addressView {
    if (!_addressView) {
        _addressView = [[DMSingleView alloc] init];
        _addressView.lcHeight = 44;
    }
    return _addressView;
}

- (DMSingleView *)detailView {
    if (!_detailView) {
        _detailView = [[DMSingleView alloc] init];
        _detailView.lcHeight = 44;
    }
    return _detailView;
}

- (DMSingleView *)reasonView {
    if (!_reasonView) {
        _reasonView = [[DMSingleView alloc] init];
        _reasonView.lcHeight = 44;
    }
    return _reasonView;
}

- (DMSingleView *)timeView {
    if (!_timeView) {
        _timeView = [[DMSingleView alloc] init];
        _timeView.lcHeight = 44;
    }
    return _timeView;
}

- (void)callPhone:(DMUserBookModel *)userInfo {
    NSInteger systemVersion = (NSInteger)([[[UIDevice currentDevice] systemVersion] floatValue] * 100);
    NSString *phoneStr = [userInfo.mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *callPhone = [NSString stringWithFormat:@"tel://%@", phoneStr];
    NSURL *url = [NSURL URLWithString:callPhone];
    if (systemVersion >= 1020) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"call_phone_number", @"呼叫%@"), userInfo.mobile] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"call_phone", @"呼叫") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }]];
        [AppRootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
