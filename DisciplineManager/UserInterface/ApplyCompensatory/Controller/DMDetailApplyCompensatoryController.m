//
//  DMDetailApplyCompensatoryController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyCompensatoryController.h"
#import "DMDetailApplyCompensatoryRequester.h"
#import "DMTaskTracksView.h"
#import "DMSubmitTaskCtaRequester.h"

@interface DMDetailApplyCompensatoryController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *startOvertimeView;
@property (nonatomic, strong) DMSingleView *endOvertimeView;
@property (nonatomic, strong) DMSingleView *totalTimeView;
@property (nonatomic, strong) DMEntryView *overtimeReasonTitleView;
@property (nonatomic, strong) DMDetailView *overtimeReasonDetailView;

@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *halfDayTitleView;
@property (nonatomic, strong) DMSingleTextView *halfDayTextView;

@property (nonatomic, strong) DMEntryView *dayTitleView;
@property (nonatomic, strong) DMSingleTextView *dayTextView;

@property (nonatomic, strong) DMEntryView *expiryDateTitleView;
@property (nonatomic, strong) DMEntrySelectView *expiryDateView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;

@property (nonatomic, strong) DMApplyCompensatoryListInfo *info;
@property (nonatomic, assign) NSTimeInterval expiryDateInterval;


@end

@implementation DMDetailApplyCompensatoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ApplyCompensatory",@"补休申请"), NSLocalizedString(@"Detail",@"详情")];
    [self refreshView];
}

- (void)refreshView {
    showLoadingDialog();
    [self getDetailInfo:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            self.info = data;
            if (self.activitiTaskModel) {
                [self.userView setTitle:@"申请人" detail:self.info.user.userInfo.name];
            } else {
                [self.stateView setTitle:@"任务状态" detail:@"待审核"];
                [self refreshState];
            }
            [self.startOvertimeView setTitle:NSLocalizedString(@"StartOvertime", @"加班开始时间") detail:self.info.startTime];
            [self.endOvertimeView setTitle:NSLocalizedString(@"EndOvertime", @"加班结束时间") detail:self.info.endTime];
            [self.totalTimeView setTitle:@"加班总时间" detail:self.info.totalTime];
            self.overtimeReasonDetailView.lcHeight = [self.overtimeReasonDetailView getHeightFromDetail:self.info.reason];
            if (self.activitiTaskModel) {
                [self.taskOperatorView refreshView:NO];
            } else {
                self.taskTracksView.taskTracks = self.info.taskTracks;
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
    if (!self.activitiTaskModel) {
        [self.subviewList addObject:self.stateView];
    } else {
        [self.subviewList addObject:self.userView];
    }
    
    [self.subviewList addObject:self.startOvertimeView];
    [self.subviewList addObject:self.endOvertimeView];
    [self.subviewList addObject:self.totalTimeView];
    [self.subviewList addObject:self.overtimeReasonTitleView];
    [self.subviewList addObject:self.overtimeReasonDetailView];
    
    if (self.activitiTaskModel) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyBXP_RSK]) {
 
            [self.subviewList addObject:self.halfDayTitleView];
            [self.subviewList addObject:self.halfDayTextView];
            [self.subviewList addObject:self.dayTitleView];
            [self.subviewList addObject:self.dayTextView];
            [self.subviewList addObject:self.expiryDateTitleView];
            [self.subviewList addObject:self.expiryDateView];
        }
        
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

- (DMSingleView *)startOvertimeView {
    if (!_startOvertimeView) {
        _startOvertimeView = [[DMSingleView alloc] init];
        _startOvertimeView.lcHeight = 44;
    }
    return _startOvertimeView;
}

- (DMSingleView *)endOvertimeView {
    if (!_endOvertimeView) {
        _endOvertimeView = [[DMSingleView alloc] init];
        _endOvertimeView.lcHeight = 44;
    }
    return _endOvertimeView;
}

- (DMSingleView *)totalTimeView {
    if (!_totalTimeView) {
        _totalTimeView = [[DMSingleView alloc] init];
        _totalTimeView.lcHeight = 44;
    }
    return _totalTimeView;
}

- (DMEntryView *)overtimeReasonTitleView {
    if (!_overtimeReasonTitleView) {
        _overtimeReasonTitleView = [[DMEntryView alloc] init];
        [_overtimeReasonTitleView setTitle:NSLocalizedString(@"OvertimeReason", @"加班事由")];
        _overtimeReasonTitleView.lcHeight = 44;
    }
    return _overtimeReasonTitleView;
}

- (DMDetailView *)overtimeReasonDetailView {
    if (!_overtimeReasonDetailView) {
        _overtimeReasonDetailView = [[DMDetailView alloc] init];
    }
    return _overtimeReasonDetailView;
}

- (DMTaskTracksView *)taskTracksView {
    if (!_taskTracksView) {
        _taskTracksView = [[DMTaskTracksView alloc] init];
    }
    return _taskTracksView;
}

- (DMEntryView *)halfDayTitleView {
    if (!_halfDayTitleView) {
        _halfDayTitleView = [[DMEntryView alloc] init];
        [_halfDayTitleView setTitle:@"发放补休票(半天)"];
        _halfDayTitleView.lcHeight = 44;
    }
    return _halfDayTitleView;
}

- (DMSingleTextView *)halfDayTextView {
    if (!_halfDayTextView) {
        _halfDayTextView = [[DMSingleTextView alloc] init];
        _halfDayTextView.lcHeight = 44;
        _halfDayTextView.backgroundColor = [UIColor whiteColor];
        [_halfDayTextView setKeyboardType:UIKeyboardTypeNumberPad];
        [_halfDayTextView setPlaceholder:@"请输入发放补休票(半天)数量"];
    }
    return _halfDayTextView;
}

- (DMEntryView *)dayTitleView {
    if (!_dayTitleView) {
        _dayTitleView = [[DMEntryView alloc] init];
        [_dayTitleView setTitle:@"发放补休票(一天)"];
        _dayTitleView.lcHeight = 44;
    }
    return _dayTitleView;
}

- (DMSingleTextView *)dayTextView {
    if (!_dayTextView) {
        _dayTextView = [[DMSingleTextView alloc] init];
        _dayTextView.lcHeight = 44;
        _dayTextView.backgroundColor = [UIColor whiteColor];
        [_dayTextView setKeyboardType:UIKeyboardTypeNumberPad];
        [_dayTextView setPlaceholder:@"请输入发放补休票(一天)数量"];
    }
    return _dayTextView;
}

- (DMEntryView *)expiryDateTitleView {
    if (!_expiryDateTitleView) {
        _expiryDateTitleView = [[DMEntryView alloc] init];
        [_expiryDateTitleView setTitle:@"有效期至"];
        _expiryDateTitleView.lcHeight = 44;
    }
    return _expiryDateTitleView;
}

- (DMEntrySelectView *)expiryDateView {
    if (!_expiryDateView) {
        _expiryDateView = [[DMEntrySelectView alloc] init];
        _expiryDateView.backgroundColor = [UIColor whiteColor];
        [_expiryDateView setPlaceholder:@"请选择有效期至时间"];
        _expiryDateView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _expiryDateView.clickEntryBlock = ^(NSString *value) {
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.expiryDateInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDate;
            picker.datePicker.minimumDate = [NSDate date];
            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
                weakSelf.expiryDateInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日";
                weakSelf.expiryDateView.value = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
            };
            [picker show];
        };
    }
    return _expiryDateView;
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
    DMDetailApplyCompensatoryRequester *requester = [[DMDetailApplyCompensatoryRequester alloc] init];
    requester.acId = self.acId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            callback(code, data);
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

#pragma mark - 审核
/*
	当definitionKey = bxp_bmld、 bxp_fgld、bxp_rsk时审核表单样式, 可以共用一个表单, 根据definitionKey 判断显示不同的表单界面
 
    分管领导审批时definitionKey =bxp_fgld,需要传递参数 emp = HR
 
    当人事科审批时definitionKey =bxp_rsk，点击同意按钮时，必须传递 补休（半天）天数、补休（一天）天数，以及有效期，需判断天数必须大于等于0， 有效期时间只能选择当前时间之后
 */
- (void)submitTask:(DMTaskOperator)taskOperator {
    if ([[self.commentTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入批注");
        return;
    }
    DMSubmitTaskCtaRequester *requester = [[DMSubmitTaskCtaRequester alloc] init];
    requester.businessId = self.acId;
    requester.taskId = self.activitiTaskModel.atId;
    requester.message = [self.commentTextView getMultiLineText];
    if (taskOperator == TaskOperator_Rejected) {
        requester.state = ACTIVITI_STATE_REJECTED;
    } else {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyBXP_RSK]) {
            // 点击同意按钮时，必须传递 补休（半天）天数、补休（一天）天数，以及有效期，需判断天数必须大于等于0， 有效期时间只能选择当前时间之后
            if (taskOperator == TaskOperator_Agree) {
                requester.state = ACTIVITI_STATE_COMPLETE;
                if ([[self.halfDayTextView getSingleText] isEqualToString:@""]) {
                    showToast(@"请输入发放补休票(半天)数量");
                    return;
                }
                if ([[self.dayTextView getSingleText] isEqualToString:@""]) {
                    showToast(@"请输入发放补休票(一天)数量");
                    return;
                }
                if ([self.expiryDateView.value isEqualToString:@""]) {
                    showToast(@"请选择有效期至时间");
                    return;
                }
                requester.number = [self.halfDayTextView getSingleText];
                requester.number2 = [self.dayTextView getSingleText];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd";
                NSDate *dt = [NSDate dateWithTimeIntervalSince1970:self.expiryDateInterval];
                requester.expiryDate = [formatter stringFromDate:dt];
            }
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyBXP_FGLD]) {
            requester.emp = @"HR";
            requester.state = ACTIVITI_STATE_PENDING;
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyBXP_BMLD]) {
            requester.state = ACTIVITI_STATE_PENDING;
        }
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
