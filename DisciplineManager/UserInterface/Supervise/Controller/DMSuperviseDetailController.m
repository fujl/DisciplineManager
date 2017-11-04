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
#import "DMMultiLineView.h"
#import "DMSelectUserController.h"
#import "DMUserBookModel.h"
#import "DMSuperviseSubmitTaskRequester.h"

@interface DMSuperviseDetailController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *sponsorView;
@property (nonatomic, strong) DMMultiLineView *coOrganizerView;
@property (nonatomic, strong) DMSingleView *deadlineView;
@property (nonatomic, strong) DMEntryView *contentTitleView;
@property (nonatomic, strong) DMDetailView *contentDetailView;

@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *transferDealerTitleView;
@property (nonatomic, strong) DMEntrySelectView *transferDealerView;
@property (nonatomic, strong) DMEntryView *coOrganizerTitleView;
@property (nonatomic, strong) DMEntrySelectView *coOrganizerSelectView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;

@property (nonatomic, strong) DMSuperviselistInfo *info;

@property (nonatomic, strong) NSMutableDictionary *selectedTransferDealerDictionary;
@property (nonatomic, strong) NSMutableDictionary *selectedCoOrganizerDictionary;

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
    [self.subviewList addObject:self.coOrganizerView];
    [self.subviewList addObject:self.deadlineView];
    [self.subviewList addObject:self.contentTitleView];
    [self.subviewList addObject:self.contentDetailView];
    
    if (self.activitiTaskModel) {
        [self.subviewList addObject:self.transferDealerTitleView];
        [self.subviewList addObject:self.transferDealerView];
        [self.subviewList addObject:self.coOrganizerTitleView];
        [self.subviewList addObject:self.coOrganizerSelectView];
        [self.subviewList addObject:self.commentTitleView];
        [self.subviewList addObject:self.commentTextView];
        [self.subviewList addObject:self.taskOperatorView];
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
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
            break;
        case ACTIVITI_STATE_REJECTED:
            self.stateView.detailLabel.text = NSLocalizedString(@"Rejected", @"驳回");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0xd9534f];
            break;
        case ACTIVITI_STATE_TIMEOUT:
            self.stateView.detailLabel.text = NSLocalizedString(@"Timeout", @"超时");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0xd9534f];
        default:
            self.stateView.detailLabel.text = NSLocalizedString(@"DataError", @"错误数据");
            self.stateView.detailLabel.backgroundColor = [UIColor colorWithRGB:0xd9534f];
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

- (DMMultiLineView *)coOrganizerView {
    if (!_coOrganizerView) {
        _coOrganizerView = [[DMMultiLineView alloc] init];
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

- (DMEntryView *)transferDealerTitleView {
    if (!_transferDealerTitleView) {
        _transferDealerTitleView = [[DMEntryView alloc] init];
        [_transferDealerTitleView setTitle:NSLocalizedString(@"transfer_dealer", @"转批办理人")];
        _transferDealerTitleView.lcHeight = 44;
    }
    return _transferDealerTitleView;
}

- (DMEntrySelectView *)transferDealerView {
    if (!_transferDealerView) {
        _transferDealerView = [[DMEntrySelectView alloc] init];
        _transferDealerView.backgroundColor = [UIColor whiteColor];
        [_transferDealerView setPlaceholder:NSLocalizedString(@"transfer_dealer_placeholder", @"请选择转批办理人(转批时必选)")];
        _transferDealerView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _transferDealerView.clickEntryBlock = ^(NSString *value) {
            [weakSelf selectTransferDealer];
        };
    }
    return _transferDealerView;
}

- (DMEntryView *)coOrganizerTitleView {
    if (!_coOrganizerTitleView) {
        _coOrganizerTitleView = [[DMEntryView alloc] init];
        [_coOrganizerTitleView setTitle:NSLocalizedString(@"add_co_organizer", @"新增协办人员")];
        _coOrganizerTitleView.lcHeight = 44;
    }
    return _coOrganizerTitleView;
}

- (DMEntrySelectView *)coOrganizerSelectView {
    if (!_coOrganizerSelectView) {
        _coOrganizerSelectView = [[DMEntrySelectView alloc] init];
        _coOrganizerSelectView.backgroundColor = [UIColor whiteColor];
        [_coOrganizerSelectView setPlaceholder:NSLocalizedString(@"co_organizer_placeholder", @"请选择协办人员(可选,多选)")];
        _coOrganizerSelectView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _coOrganizerSelectView.clickEntryBlock = ^(NSString *value) {
            [weakSelf selectCoOrganizer];
        };
    }
    return _coOrganizerSelectView;
}

- (DMEntryView *)commentTitleView {
    if (!_commentTitleView) {
        _commentTitleView = [[DMEntryView alloc] init];
        [_commentTitleView setTitle:@"批注"];
        _commentTitleView.lcHeight = 44;
    }
    return _commentTitleView;
}

- (DMMultiLineTextView *)commentTextView {
    if (!_commentTextView) {
        _commentTextView = [[DMMultiLineTextView alloc] init];
        _commentTextView.lcHeight = 200;
        _commentTextView.backgroundColor = [UIColor whiteColor];
        [_commentTextView setPlaceholder:@"请输入批注(最多200字)"];
        [_commentTextView setText:@"同意"];
    }
    return _commentTextView;
}

-(DMTaskOperatorView *)taskOperatorView {
    if (!_taskOperatorView) {
        _taskOperatorView = [[DMTaskOperatorView alloc] init];
        _taskOperatorView.lcHeight = 64;
        [_taskOperatorView refreshSupervisionTaskView:[self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyDBRW_BLRW]];
        __weak typeof(self) weakSelf = self;
        _taskOperatorView.clickTaskOperatorBlock = ^(DMTaskOperator taskOperator) {
            [weakSelf submitTask:taskOperator];
        };
    }
    return _taskOperatorView;
}

- (void)setSelectedTransferDealerDictionary:(NSMutableDictionary *)selectedTransferDealerDictionary {
    _selectedTransferDealerDictionary = selectedTransferDealerDictionary;
    NSString *transferDealerString = @"";
    for (DMUserBookModel *mdl in [selectedTransferDealerDictionary allValues]) {
        if ([transferDealerString isEqualToString:@""]) {
            transferDealerString = mdl.name;
        } else {
            transferDealerString = [NSString stringWithFormat:@"%@,%@", transferDealerString, mdl.name];
        }
    }
    self.transferDealerView.value = transferDealerString;
}

- (void)setSelectedCoOrganizerDictionary:(NSMutableDictionary *)selectedCoOrganizerDictionary {
    _selectedCoOrganizerDictionary = selectedCoOrganizerDictionary;
    NSString *coOrganizerString = @"";
    for (DMUserBookModel *mdl in [selectedCoOrganizerDictionary allValues]) {
        if ([coOrganizerString isEqualToString:@""]) {
            coOrganizerString = mdl.name;
        } else {
            coOrganizerString = [NSString stringWithFormat:@"%@,%@", coOrganizerString, mdl.name];
        }
    }
    self.coOrganizerSelectView.value = coOrganizerString;
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

#pragma mark - 事件
- (void)selectTransferDealer {
    DMSelectUserController *controller = [[DMSelectUserController alloc] init];
    controller.isRadio = YES;
    __weak typeof(self) weakSelf = self;
    controller.onSelectUserBlock = ^(NSMutableDictionary *userDict) {
        weakSelf.selectedTransferDealerDictionary = userDict;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectCoOrganizer {
    DMSelectUserController *controller = [[DMSelectUserController alloc] init];
    __weak typeof(self) weakSelf = self;
    controller.onSelectUserBlock = ^(NSMutableDictionary *userDict) {
        weakSelf.selectedCoOrganizerDictionary = userDict;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 审核
- (void)submitTask:(DMTaskOperator)taskOperator {
    if ([[self.commentTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入批注");
        return;
    }
    DMSuperviseSubmitTaskRequester *requester = [[DMSuperviseSubmitTaskRequester alloc] init];
    requester.businessId = self.slId;
    requester.taskId = self.activitiTaskModel.atId;
    requester.message = [self.commentTextView getMultiLineText];
    NSString *assistsId = @"";
    if (self.selectedCoOrganizerDictionary) {
        if (self.selectedCoOrganizerDictionary.count > 0) {
            for (DMUserBookModel *user in [self.selectedCoOrganizerDictionary allValues]) {
                if ([assistsId isEqualToString:@""]) {
                    assistsId = [NSString stringWithFormat:@"%@@%@", user.userId, user.name];
                } else {
                    assistsId = [NSString stringWithFormat:@"%@,%@@%@", assistsId, user.userId, user.name];
                }
            }
        }
    }
    requester.assistsId = assistsId;
    if (taskOperator == TaskOperator_Agree) {
        requester.state = 2;
    } else if (taskOperator == TaskOperator_TransferComment) {
        NSString *agentId = @"";
        if (self.selectedTransferDealerDictionary) {
            for (DMUserBookModel *user in [self.selectedTransferDealerDictionary allValues]) {
                agentId = user.userId;
            }
        }
        if ([agentId isEqualToString:@""]) {
            showToast(@"请选择转批办理人员");
            return;
        }
        requester.state = 4;
        requester.agentId = agentId;
    } else {
        showToast(@"逻辑错误");
        return;
    }
    
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            showToast(data);
        }
    }];
}

@end
