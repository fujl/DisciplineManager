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
#import "DMSearchUserRequester.h"
#import "DMUserBookModel.h"
#import "DMPickerView.h"
#import "DMImageCollectionView.h"
#import "DMSelectUserController.h"

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
@property (nonatomic, strong) DMEntryView *imgTitleView;
@property (nonatomic, strong) DMImageCollectionView *imgView;
@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *leaderTitleView;
@property (nonatomic, strong) DMEntrySelectView *leaderView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;

@property (nonatomic, strong) DMApplyLeaveListInfo *info;
@property (nonatomic, strong) NSMutableArray<DMUserBookModel*> *leaderList;
@property (nonatomic, strong) DMUserBookModel *leader;

@property (nonatomic, strong) NSMutableDictionary *selectedTransferDealerDictionary;

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
            self.info = data;
            if (self.activitiTaskModel) {
                [self.userView setTitle:@"申请人" detail:self.info.user.userInfo.name];
            } else {
                [self.stateView setTitle:@"任务状态" detail:@"待审核"];
                [self refreshState:self.info];
            }
            [self.typeView setTitle:NSLocalizedString(@"LeaveType", @"请(休)假类别") detail:self.info.type == LeaveTypeDefault ? @"请假" : @"休假"];
            NSString *startDtString = [NSString stringWithFormat:@"%@ %@", self.info.startTime, self.info.startTimeType == DMDateTypeMorning ? NSLocalizedString(@"morning", @"上午") : NSLocalizedString(@"afternoon", @"上午")];
            [self.startDtView setTitle:NSLocalizedString(@"StartTime", @"开始时间") detail:startDtString];
            NSString *endDtString = [NSString stringWithFormat:@"%@ %@", self.info.endTime, self.info.endTimeType == DMDateTypeMorning ? NSLocalizedString(@"morning", @"上午") : NSLocalizedString(@"afternoon", @"上午")];
            [self.endDtView setTitle:NSLocalizedString(@"EndTime", @"结束时间") detail:endDtString];
            [self.holidaysView setTitle:NSLocalizedString(@"Holidays", @"节假日") detail:self.info.holiday];
            [self.actualLeaveNumberView setTitle:NSLocalizedString(@"ActualLeaveNumber", @"实际请(休)假天数") detail:[NSString stringWithFormat:@"%0.1f天", self.info.days]];
            self.leaveReasonDetailView.lcHeight = [self.leaveReasonDetailView getHeightFromDetail:self.info.reason];
            if (self.info.attrs.count > 0) {
                NSMutableArray *attr = [[NSMutableArray alloc] init];
                for (DMAttrModel *mdl in self.info.attrs) {
                    [attr addObject:mdl.path];
                }
                self.imgView.imageStringList = attr;
            }
            if (self.activitiTaskModel) {
//                [self.taskOperatorView refreshView:[self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_FGLD] && self.info.state==ACTIVITI_STATE_PENDING];
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
    if (self.info.attrs.count > 0) {
        [self.subviewList addObject:self.imgTitleView];
        [self.subviewList addObject:self.imgView];
    }
    if (self.activitiTaskModel) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_FGLD] && self.info.state==ACTIVITI_STATE_PENDING) {
            [self loadLeaderData];
            [self.subviewList addObject:self.leaderTitleView];
            [self.subviewList addObject:self.leaderView];
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_BMLD]) {
            [self.subviewList addObject:self.leaderTitleView];
            [self.subviewList addObject:self.leaderView];
        }
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

- (DMEntryView *)imgTitleView {
    if (!_imgTitleView) {
        _imgTitleView = [[DMEntryView alloc] init];
        [_imgTitleView setTitle:NSLocalizedString(@"PictureAccessories", @"图片附件")];
        _imgTitleView.lcHeight = 44;
    }
    return _imgTitleView;
}

- (DMImageCollectionView *)imgView {
    if (!_imgView) {
        _imgView = [[DMImageCollectionView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
    }
    return _imgView;
}

- (DMTaskTracksView *)taskTracksView {
    if (!_taskTracksView) {
        _taskTracksView = [[DMTaskTracksView alloc] init];
    }
    return _taskTracksView;
}

- (DMEntryView *)leaderTitleView {
    if (!_leaderTitleView) {
        _leaderTitleView = [[DMEntryView alloc] init];
        [_leaderTitleView setTitle:@"转批领导"];
        _leaderTitleView.lcHeight = 44;
    }
    return _leaderTitleView;
}

- (DMEntrySelectView *)leaderView {
    if (!_leaderView) {
        _leaderView = [[DMEntrySelectView alloc] init];
        _leaderView.backgroundColor = [UIColor whiteColor];
        [_leaderView setPlaceholder:@"请选择转批领导"];
        _leaderView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _leaderView.clickEntryBlock = ^(NSString *value) {
            if ([weakSelf.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_BMLD]) {
                [weakSelf selectTransferDealer];
            } else {
                DMPickerView *pickerView = [[DMPickerView alloc] initWithArr:[weakSelf dicArr]];
                if (weakSelf.leader) {
                    [pickerView selectID:weakSelf.leader.userId];
                } else {
                    [pickerView selectID:weakSelf.leaderList.firstObject.userId];
                }
                pickerView.onCompleteClick = ^(NSDictionary *dic){
                    for (DMUserBookModel *mdl in weakSelf.leaderList) {
                        if ([mdl.userId isEqualToString:dic[@"value"]]) {
                            weakSelf.leader = mdl;
                            break;
                        }
                    }
                    [weakSelf.leaderView setValue:weakSelf.leader.name];
                };
                [pickerView showPickerView];
            }
        };
    }
    return _leaderView;
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
    self.leaderView.value = transferDealerString;
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

- (void)loadLeaderData {
    DMSearchUserRequester *requester = [[DMSearchUserRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = 0;
    // 转批领导人员选择接口传递参数: 001001
    // requester.orgId = @"001002";
    requester.orgId = @"001001";
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            self.leaderList = listModel.rows;
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
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_BMLD]) {
            NSString *leader = @"";
            if (self.selectedTransferDealerDictionary) {
                for (DMUserBookModel *user in [self.selectedTransferDealerDictionary allValues]) {
                    leader = user.userId;
                }
            }
            if ([leader isEqualToString:@""]) {
                if(self.info.days <= 3) {
                    requester.state = ACTIVITI_STATE_COMPLETE;
                } else {
                    requester.state = ACTIVITI_STATE_PENDING;
                }
            } else {
                // 转批
                requester.state = ACTIVITI_STATE_TRANSFERDEALER;
                requester.leaderId2 = leader;
            }
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyQJSQ_FGLD]) {
            if (!self.leader) {
                // showToast(@"请选择转批领导");
                requester.state = ACTIVITI_STATE_COMPLETE;
            } else {
                requester.leaderId = self.leader.userId;
                requester.state = ACTIVITI_STATE_PENDING;
            }
        } else {
            requester.state = ACTIVITI_STATE_COMPLETE;
        }
    } else if (taskOperator == TaskOperator_Rejected) {
        requester.state = ACTIVITI_STATE_REJECTED;
    } else {
        // 转批
        if (!self.leader) {
            showToast(@"请选择转批领导");
            return;
        }
        requester.leaderId = self.leader.userId;
        requester.state = ACTIVITI_STATE_PENDING;
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

- (NSMutableArray *)dicArr {
    NSMutableArray *dicArr = [[NSMutableArray alloc] init];
    for (DMUserBookModel *mdl in self.leaderList) {
        NSDictionary *dic = @{@"name":mdl.name,@"value":[NSString stringWithFormat:@"%@",mdl.userId]};
        [dicArr addObject:dic];
    }
    return dicArr;
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

@end
