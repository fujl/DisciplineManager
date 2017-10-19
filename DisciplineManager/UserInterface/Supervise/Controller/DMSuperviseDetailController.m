//
//  DMSuperviseDetailController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviseDetailController.h"
#import "DMSuperviseGetRequester.h"
#import "DMTaskTracksView.h"
#import "DMSuperviselistInfo.h"

@interface DMSuperviseDetailController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *sponsorView;
@property (nonatomic, strong) DMSingleView *coOrganizerView;
@property (nonatomic, strong) DMSingleView *deadlineView;
@property (nonatomic, strong) DMEntryView *contentTitleView;
@property (nonatomic, strong) DMDetailView *contentDetailView;

@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMSuperviselistInfo *info;

@end

@implementation DMSuperviseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"temporary_task", @"督办任务"), NSLocalizedString(@"Detail",@"详情")];
    [self refreshView];
}

- (void)refreshView {
    showLoadingDialog();
    [self getDetailInfo:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            self.info = data;
            if (!self.activitiTaskModel) {
                [self.stateView setTitle:@"任务状态" detail:@"待审核"];
                [self refreshState];
            } else {
                [self.userView setTitle:@"申请人" detail:self.info.user.userInfo.name];
            }
            [self.sponsorView setTitle:@"主办人" detail:self.info.transactorName];
            NSString *assists = @"";
            for (DMAssistInfo *assistInfo in self.info.assists) {
                if ([assists isEqualToString:@""]) {
                    assists = assistInfo.name;
                } else {
                    assists = [NSString stringWithFormat:@"%@,%@", assists, assistInfo.name];
                }
            }
            [self.coOrganizerView setTitle:NSLocalizedString(@"co_organizer", @"协办人员") detail:assists];
            [self.deadlineView setTitle:NSLocalizedString(@"Deadline", @"截止日期") detail:self.info.endTime];
            self.contentDetailView.lcHeight = [self.contentDetailView getHeightFromDetail:self.info.reason];
            if (self.activitiTaskModel) {
//                if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_WCHG]) {
//                    // 完成回岗
//                    [self.taskOperatorView refreshFinishHuigangView];
//                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_JSY]) {
//                    [self.taskOperatorView refreshJsyView];
//                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD]) {
//                    [self.taskOperatorView refreshView:NO];
//                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_TJLD]
//                           || [self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP]) {
//                    [self.taskOperatorView refreshView:NO];
//                }
            } else {
                self.taskTracksView.taskTracks = self.info.taskTracks;
            }
            [self loadSubview];
        }
    }];
}

- (void)loadSubview {
    [self.subviewList removeAllObjects];
    if (!self.activitiTaskModel) {
        [self.subviewList addObject:self.stateView];
    } else {
        [self.subviewList addObject:self.userView];
    }
    [self.subviewList addObject:self.sponsorView];
    if (self.activitiTaskModel) {
//        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP]) {
//            [self.subviewList addObject:self.driverNameView];
//            [self.subviewList addObject:self.officialCarView];
//        }
    }
    [self.subviewList addObject:self.coOrganizerView];
    [self.subviewList addObject:self.deadlineView];
    [self.subviewList addObject:self.contentTitleView];
    [self.subviewList addObject:self.contentDetailView];
    
    if (self.activitiTaskModel) {
//        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD]) {
//            [self loadLeaderData];
//            [self.subviewList addObject:self.leaderTitleView];
//            [self.subviewList addObject:self.leaderView];
//        }
//        [self.subviewList addObject:self.commentTitleView];
//        [self.subviewList addObject:self.commentTextView];
//        [self.subviewList addObject:self.taskOperatorView];
//
    } else {
        [self.subviewList addObject:self.taskTracksView];
    }
    
    [self setChildViews:self.subviewList];
}

- (void)refreshState {
    self.stateView.detailLabel.textColor = [UIColor whiteColor];
    switch (self.info.state) {
        case ACTIVITI_STATE_SAVE:
            self.stateView.detailLabel.text = NSLocalizedString(@"Save", @"保存");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
            break;
        case ACTIVITI_STATE_PENDING:
            self.stateView.detailLabel.text = NSLocalizedString(@"Pending", @"待审核");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x337ab7];
            break;
        case ACTIVITI_STATE_COMPLETE:
            self.stateView.detailLabel.text = NSLocalizedString(@"Complete", @"已完成");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
            break;
        case ACTIVITI_STATE_RATIFIED:
            self.stateView.detailLabel.text = NSLocalizedString(@"Ratified", @"已批准");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
            break;
        case ACTIVITI_STATE_REJECTED:
            self.stateView.detailLabel.text = NSLocalizedString(@"Rejected", @"驳回");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0xd9534f];
            break;
        default:
            self.stateView.detailLabel.text = NSLocalizedString(@"DataError", @"错误数据");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x777777];
            break;
    }
    [self.stateView refreshSize:CGSizeMake(50, 30)];
    self.stateView.detailLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMSingleView *)userView {
    if (!_userView) {
        _userView = [[DMSingleView alloc] init];
        _userView.lcHeight = 44;
    }
    return _userView;
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

- (DMSingleView *)sponsorView {
    if (!_sponsorView) {
        _sponsorView = [[DMSingleView alloc] init];
        _sponsorView.lcHeight = 44;
    }
    return _sponsorView;
}

- (DMSingleView *)coOrganizerView {
    if (!_coOrganizerView) {
        _coOrganizerView = [[DMSingleView alloc] init];
        _coOrganizerView.lcHeight = 44;
    }
    return _coOrganizerView;
}

- (DMSingleView *)deadlineView {
    if (!_deadlineView) {
        _deadlineView = [[DMSingleView alloc] init];
        _deadlineView.lcHeight = 44;
    }
    return _deadlineView;
}

- (DMEntryView *)contentTitleView {
    if (!_contentTitleView) {
        _contentTitleView = [[DMEntryView alloc] init];
        [_contentTitleView setTitle:NSLocalizedString(@"TaskContent", @"任务内容")];
        _contentTitleView.lcHeight = 44;
    }
    return _contentTitleView;
}

- (DMDetailView *)contentDetailView {
    if (!_contentDetailView) {
        _contentDetailView = [[DMDetailView alloc] init];
    }
    return _contentDetailView;
}

- (DMTaskTracksView *)taskTracksView {
    if (!_taskTracksView) {
        _taskTracksView = [[DMTaskTracksView alloc] init];
    }
    return _taskTracksView;
}

#pragma mark - get data
- (void)getDetailInfo:(void (^)(DMResultCode code, id data))callback {
    DMSuperviseGetRequester *requester = [[DMSuperviseGetRequester alloc] init];
    requester.slId = self.slId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            callback(code, data);
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
            callback(code, errMsg);
        }
    }];
}

@end
