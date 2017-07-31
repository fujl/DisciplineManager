//
//  DMDetailApplyLeaveController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyLeaveController.h"
#import "DMDetailApplyLeaveRequester.h"
#import "DMApplyLeaveListInfo.h"
#import "DMTaskTracksView.h"
#import "DMSubmitTaskLeaveRequester.h"

@interface DMDetailApplyLeaveController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *typeView;
@property (nonatomic, strong) DMSingleView *startDtView;
@property (nonatomic, strong) DMSingleView *endDtView;
@property (nonatomic, strong) DMSingleView *holidaysView;
@property (nonatomic, strong) DMSingleView *actualLeaveNumberView;
@property (nonatomic, strong) DMEntryView *leaveReasonTitleView;
@property (nonatomic, strong) DMDetailView *leaveReasonDetailView;
@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;
@end

@implementation DMDetailApplyLeaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ApplyLeave",@"请假申请"), NSLocalizedString(@"Detail",@"详情")];
    [self refreshView];
}

- (void)refreshView {
    showLoadingDialog();
    [self getDetailInfo:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            DMApplyLeaveListInfo *info = data;
            if (self.activitiTaskModel) {
                [self.userView setTitle:@"申请人" detail:self.activitiTaskModel.user.userInfo.name];
            } else {
                [self.stateView setTitle:@"任务状态" detail:@"待审核"];
                [self refreshState:info];
            }
            [self.typeView setTitle:NSLocalizedString(@"LeaveType", @"请(休)假类别") detail:info.type == LeaveTypeDefault ? @"请假" : @"休假"];
            NSString *startDtString = [NSString stringWithFormat:@"%@ %@", info.startTime, info.startTimeType == DMDateTypeMorning ? NSLocalizedString(@"morning", @"上午") : NSLocalizedString(@"afternoon", @"上午")];
            [self.startDtView setTitle:NSLocalizedString(@"StartTime", @"开始时间") detail:startDtString];
            NSString *endDtString = [NSString stringWithFormat:@"%@ %@", info.endTime, info.endTimeType == DMDateTypeMorning ? NSLocalizedString(@"morning", @"上午") : NSLocalizedString(@"afternoon", @"上午")];
            [self.endDtView setTitle:NSLocalizedString(@"EndTime", @"结束时间") detail:endDtString];
            [self.holidaysView setTitle:NSLocalizedString(@"Holidays", @"节假日") detail:info.holiday];
            [self.actualLeaveNumberView setTitle:NSLocalizedString(@"ActualLeaveNumber", @"实际请(休)假天数") detail:[NSString stringWithFormat:@"%0.1f天", info.days]];
            self.leaveReasonDetailView.lcHeight = [self.leaveReasonDetailView getHeightFromDetail:info.reason];
            if (self.activitiTaskModel) {
                [self.taskOperatorView refreshView:[self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_FGLD] && info.state==ACTIVITI_STATE_PENDING];
            } else {
                self.taskTracksView.taskTracks = info.taskTracks;
            }
            [self loadSubview];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)loadSubview {
    [self.subviewList removeAllObjects];
    if (self.activitiTaskModel) {
        [self.subviewList addObject:self.userView];
    } else {
        [self.subviewList addObject:self.stateView];
    }
    [self.subviewList addObject:self.typeView];
    
    [self.subviewList addObject:self.startDtView];
    [self.subviewList addObject:self.endDtView];
    
    [self.subviewList addObject:self.holidaysView];
    [self.subviewList addObject:self.actualLeaveNumberView];
    
    [self.subviewList addObject:self.leaveReasonTitleView];
    [self.subviewList addObject:self.leaveReasonDetailView];
    if (self.activitiTaskModel) {
        [self.subviewList addObject:self.commentTitleView];
        [self.subviewList addObject:self.commentTextView];
        [self.subviewList addObject:self.taskOperatorView];
    } else {
        [self.subviewList addObject:self.taskTracksView];
    }
    [self setChildViews:self.subviewList];
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

- (DMSingleView *)typeView {
    if (!_typeView) {
        _typeView = [[DMSingleView alloc] init];
        _typeView.lcHeight = 44;
    }
    return _typeView;
}

- (DMSingleView *)startDtView {
    if (!_startDtView) {
        _startDtView = [[DMSingleView alloc] init];
        _startDtView.lcHeight = 44;
    }
    return _startDtView;
}

- (DMSingleView *)endDtView {
    if (!_endDtView) {
        _endDtView = [[DMSingleView alloc] init];
        _endDtView.lcHeight = 44;
    }
    return _endDtView;
}

- (DMSingleView *)holidaysView {
    if (!_holidaysView) {
        _holidaysView = [[DMSingleView alloc] init];
        _holidaysView.lcHeight = 44;
    }
    return _holidaysView;
}

- (DMSingleView *)actualLeaveNumberView {
    if (!_actualLeaveNumberView) {
        _actualLeaveNumberView = [[DMSingleView alloc] init];
        _actualLeaveNumberView.lcHeight = 44;
    }
    return _actualLeaveNumberView;
}

- (DMEntryView *)leaveReasonTitleView {
    if (!_leaveReasonTitleView) {
        _leaveReasonTitleView = [[DMEntryView alloc] init];
        [_leaveReasonTitleView setTitle:NSLocalizedString(@"LeaveReason", @"请(休)假事由")];
        _leaveReasonTitleView.lcHeight = 44;
    }
    return _leaveReasonTitleView;
}

- (DMDetailView *)leaveReasonDetailView {
    if (!_leaveReasonDetailView) {
        _leaveReasonDetailView = [[DMDetailView alloc] init];
    }
    return _leaveReasonDetailView;
}

- (DMTaskTracksView *)taskTracksView {
    if (!_taskTracksView) {
        _taskTracksView = [[DMTaskTracksView alloc] init];
    }
    return _taskTracksView;
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
    }
    return _commentTextView;
}

-(DMTaskOperatorView *)taskOperatorView {
    if (!_taskOperatorView) {
        _taskOperatorView = [[DMTaskOperatorView alloc] init];
        _taskOperatorView.lcHeight = 64;
        __weak typeof(self) weakSelf = self;
        _taskOperatorView.clickTaskOperatorBlock = ^(DMTaskOperator taskOperator) {
            [weakSelf submitTask:taskOperator];
        };
    }
    return _taskOperatorView;
}

#pragma mark - get data
- (void)getDetailInfo:(void (^)(DMResultCode code, id data))callback {
    DMDetailApplyLeaveRequester *requester = [[DMDetailApplyLeaveRequester alloc] init];
    requester.alId = self.alId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            callback(code, data);
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

- (void)refreshState:(DMApplyLeaveListInfo *)info {
    self.stateView.detailLabel.textColor = [UIColor whiteColor];
    switch (info.state) {
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

#pragma mark - 审核
- (void)submitTask:(DMTaskOperator)taskOperator {
    if ([[self.commentTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入批注");
        return;
    }
    DMSubmitTaskLeaveRequester *requester = [[DMSubmitTaskLeaveRequester alloc] init];
    requester.businessId = self.alId;
    requester.taskId = self.activitiTaskModel.atId;
    requester.message = [self.commentTextView getMultiLineText];
    if (taskOperator == TaskOperator_Agree) {
        requester.state = ACTIVITI_STATE_COMPLETE;
    } else if (taskOperator == TaskOperator_Rejected) {
        requester.state = ACTIVITI_STATE_REJECTED;
    } else {
        requester.state = ACTIVITI_STATE_PENDING;
        requester.leaderId = self.activitiTaskModel.businessId;
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
