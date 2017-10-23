//
//  DMDetailApplyOutController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyOutController.h"
#import "DMDetailApplyOutRequester.h"
#import "DMApplyOutListInfo.h"
#import "DMTaskTracksView.h"
#import "DMSubmitTaskOutRequester.h"
#import "DMOfficialCarModel.h"
#import "DMPickerView.h"
#import "DMUserBookModel.h"
#import "DMSearchUserRequester.h"
#import "DMSearchOfficialCarRequester.h"
#import "DMMultiLineView.h"
#import "DMSelectUserController.h"

@interface DMDetailApplyOutController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *outTimeView;
@property (nonatomic, strong) DMSingleView *returnTimeView;
@property (nonatomic, strong) DMMultiLineView *addressView;
@property (nonatomic, strong) DMSingleView *driverNameView;
@property (nonatomic, strong) DMSingleView *officialCarView;
@property (nonatomic, strong) DMSingleView *needBusView;
@property (nonatomic, strong) DMEntryView *outReasonTitleView;
@property (nonatomic, strong) DMDetailView *outReasonDetailView;

@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *leaderTitleView;
@property (nonatomic, strong) DMEntrySelectView *leaderView;

@property (nonatomic, strong) DMEntryView *driverTitleView;
@property (nonatomic, strong) DMEntrySelectView *driverView;

@property (nonatomic, strong) DMEntryView *officialCarIdTitleView;
@property (nonatomic, strong) DMEntrySelectView *officialCarIdView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;

@property (nonatomic, strong) DMApplyOutListInfo *info;

@property (nonatomic, strong) NSMutableArray<DMUserBookModel*> *driverList;
@property (nonatomic, strong) DMUserBookModel *driver;

@property (nonatomic, strong) NSMutableArray<DMOfficialCarModel*> *officialCarList;
@property (nonatomic, strong) DMOfficialCarModel *officialCar;

@property (nonatomic, strong) NSMutableDictionary *selectedTransferDealerDictionary;

@end

@implementation DMDetailApplyOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ApplyOut",@"外出申请"), NSLocalizedString(@"Detail",@"详情")];
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
            [self.outTimeView setTitle:NSLocalizedString(@"OutTime", @"外出时间") detail:self.info.startTime];
            NSString *returnTime = self.info.endTime && ![self.info.endTime isEqualToString:@""] ? self.info.endTime : @"未回岗";
            [self.returnTimeView setTitle:NSLocalizedString(@"ReturnTime", @"回岗时间") detail:returnTime];
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@", self.info.province, self.info.city, self.info.county, self.info.address];
            [self.addressView setTitle:NSLocalizedString(@"OutAddress", @"外出地址") detail:address];
            NSString *needBus = self.info.isNeedCar == 1 ? NSLocalizedString(@"need", @"需要") : NSLocalizedString(@"no_need", @"不需要");
            [self.needBusView setTitle:NSLocalizedString(@"IsNeedBus", @"是否需要公车") detail:needBus];
            if (self.activitiTaskModel) {
                if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_WCHG]) {
                    if (self.info.isNeedCar == 1) {
                        [self.driverNameView setTitle:@"司机姓名" detail:self.info.driverName];
                        [self.officialCarView setTitle:@"车牌号码" detail:self.info.officialCar.number];
                    }
                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_JSY]) {
                    [self.officialCarView setTitle:@"车牌号码" detail:self.info.officialCar.number];
                }
            }
            self.outReasonDetailView.lcHeight = [self.outReasonDetailView getHeightFromDetail:self.info.reason];
            if (self.activitiTaskModel) {
                if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_WCHG]) {
                    // 完成回岗
                    [self.taskOperatorView refreshFinishHuigangView];
                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_JSY]) {
                    [self.taskOperatorView refreshJsyView];
                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD]) {
                    [self.taskOperatorView refreshView:NO];
                } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_TJLD]
                           || [self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP]) {
                    [self.taskOperatorView refreshView:NO];
                }
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
    [self.subviewList addObject:self.outTimeView];
    [self.subviewList addObject:self.returnTimeView];
    [self.subviewList addObject:self.addressView];
    [self.subviewList addObject:self.needBusView];
    if (self.activitiTaskModel) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_WCHG]) {
            if (self.info.isNeedCar == 1) {
                [self.subviewList addObject:self.driverNameView];
                [self.subviewList addObject:self.officialCarView];
            }
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_JSY]) {
            [self.subviewList addObject:self.officialCarView];
        }
    }
    [self.subviewList addObject:self.outReasonTitleView];
    [self.subviewList addObject:self.outReasonDetailView];
    
    if (self.activitiTaskModel) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD]) {
            [self.subviewList addObject:self.leaderTitleView];
            [self.subviewList addObject:self.leaderView];
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP]) {
            [self loadDriverData];
            [self loadOfficialCarData];
            [self.subviewList addObject:self.driverTitleView];
            [self.subviewList addObject:self.driverView];
            [self.subviewList addObject:self.officialCarIdTitleView];
            [self.subviewList addObject:self.officialCarIdView];
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

- (DMSingleView *)outTimeView {
    if (!_outTimeView) {
        _outTimeView = [[DMSingleView alloc] init];
        _outTimeView.lcHeight = 44;
    }
    return _outTimeView;
}

- (DMSingleView *)returnTimeView {
    if (!_returnTimeView) {
        _returnTimeView = [[DMSingleView alloc] init];
        _returnTimeView.lcHeight = 44;
    }
    return _returnTimeView;
}

- (DMSingleView *)driverNameView {
    if (!_driverNameView) {
        _driverNameView = [[DMSingleView alloc] init];
        _driverNameView.lcHeight = 44;
    }
    return _driverNameView;
}

- (DMSingleView *)officialCarView {
    if (!_officialCarView) {
        _officialCarView = [[DMSingleView alloc] init];
        _officialCarView.lcHeight = 44;
    }
    return _officialCarView;
}

- (DMMultiLineView *)addressView {
    if (!_addressView) {
        _addressView = [[DMMultiLineView alloc] init];
        _addressView.lcHeight = 44;
    }
    return _addressView;
}

- (DMSingleView *)needBusView {
    if (!_needBusView) {
        _needBusView = [[DMSingleView alloc] init];
        _needBusView.lcHeight = 44;
    }
    return _needBusView;
}

- (DMEntryView *)outReasonTitleView {
    if (!_outReasonTitleView) {
        _outReasonTitleView = [[DMEntryView alloc] init];
        [_outReasonTitleView setTitle:NSLocalizedString(@"OutReason", @"外出事由")];
        _outReasonTitleView.lcHeight = 44;
    }
    return _outReasonTitleView;
}

- (DMDetailView *)outReasonDetailView {
    if (!_outReasonDetailView) {
        _outReasonDetailView = [[DMDetailView alloc] init];
    }
    return _outReasonDetailView;
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
            [weakSelf selectTransferDealer];
        };
    }
    return _leaderView;
}

- (DMEntryView *)driverTitleView {
    if (!_driverTitleView) {
        _driverTitleView = [[DMEntryView alloc] init];
        [_driverTitleView setTitle:@"选择司机"];
        _driverTitleView.lcHeight = 44;
    }
    return _driverTitleView;
}

- (DMEntrySelectView *)driverView {
    if (!_driverView) {
        _driverView = [[DMEntrySelectView alloc] init];
        _driverView.backgroundColor = [UIColor whiteColor];
        [_driverView setPlaceholder:@"请选择司机"];
        _driverView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _driverView.clickEntryBlock = ^(NSString *value) {
            if ([weakSelf dicArr].count > 0) {
                DMPickerView *pickerView = [[DMPickerView alloc] initWithArr:[weakSelf dicArr]];
                if (weakSelf.driver) {
                    [pickerView selectID:weakSelf.driver.userId];
                } else {
                    [pickerView selectID:weakSelf.driverList.firstObject.userId];
                }
                pickerView.onCompleteClick = ^(NSDictionary *dic){
                    for (DMUserBookModel *mdl in weakSelf.driverList) {
                        if ([mdl.userId isEqualToString:dic[@"value"]]) {
                            weakSelf.driver = mdl;
                            break;
                        }
                    }
                    [weakSelf.driverView setValue:weakSelf.driver.name];
                };
                [pickerView showPickerView];
            } else {
                showToast(@"数据异常，请联系管理员");
            }
        };
    }
    return _driverView;
}

- (DMEntryView *)officialCarIdTitleView {
    if (!_officialCarIdTitleView) {
        _officialCarIdTitleView = [[DMEntryView alloc] init];
        [_officialCarIdTitleView setTitle:@"选择车辆"];
        _officialCarIdTitleView.lcHeight = 44;
    }
    return _officialCarIdTitleView;
}

- (DMEntrySelectView *)officialCarIdView {
    if (!_officialCarIdView) {
        _officialCarIdView = [[DMEntrySelectView alloc] init];
        _officialCarIdView.backgroundColor = [UIColor whiteColor];
        [_officialCarIdView setPlaceholder:@"请选择车辆"];
        _officialCarIdView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _officialCarIdView.clickEntryBlock = ^(NSString *value) {
            if (weakSelf.officialCarList && weakSelf.officialCarList.count > 0) {
                DMPickerView *pickerView = [[DMPickerView alloc] initWithArr:[weakSelf dicOfficialCarIdArr]];
                if (weakSelf.driver) {
                    [pickerView selectID:weakSelf.officialCar.ocId];
                } else {
                    [pickerView selectID:weakSelf.officialCarList.firstObject.ocId];
                }
                pickerView.onCompleteClick = ^(NSDictionary *dic) {
                    for (DMOfficialCarModel *mdl in weakSelf.officialCarList) {
                        if ([mdl.ocId isEqualToString:dic[@"value"]]) {
                            weakSelf.officialCar = mdl;
                            break;
                        }
                    }
                    [weakSelf.officialCarIdView setValue:weakSelf.officialCar.state>0?[NSString stringWithFormat:@"%@ (外出)", weakSelf.officialCar.number]:weakSelf.officialCar.number];
                };
                [pickerView showPickerView];
            } else {
                showToast(@"数据异常，请联系管理员");
            }
        };
    }
    return _officialCarIdView;
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
    DMDetailApplyOutRequester *requester = [[DMDetailApplyOutRequester alloc] init];
    requester.aoId = self.aoId;
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

- (void)loadDriverData {
    DMSearchUserRequester *requester = [[DMSearchUserRequester alloc] init];
    requester.limit = kPageSize;
    requester.offset = 0;
    //    requester.orgId = @"001004001";
    // 司机选择接口orgId传递: 001002001
    requester.orgId = @"001002001";
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            self.driverList = listModel.rows;
        }
    }];
}

- (void)loadOfficialCarData {
    DMSearchOfficialCarRequester *requester = [[DMSearchOfficialCarRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            self.officialCarList = listModel.rows;
        }
    }];
}

#pragma mark - 审核
- (void)submitTask:(DMTaskOperator)taskOperator {
    if ([[self.commentTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入批注");
        return;
    }
    DMSubmitTaskOutRequester *requester = [[DMSubmitTaskOutRequester alloc] init];
    requester.businessId = self.aoId;
    requester.taskId = self.activitiTaskModel.atId;
    requester.message = [self.commentTextView getMultiLineText];
    
    if (taskOperator == TaskOperator_Agree) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP]) {
            if (!self.driver) {
                showToast(@"请选择司机");
                return;
            }
            requester.driverId = self.driver.userId;
            requester.driverName = self.driver.name;
            
            if (!self.officialCar) {
                showToast(@"请选择车牌");
                return;
            }
            requester.officialCarId = self.officialCar.ocId;
            requester.state = @([self getAgree]);
        } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD]) {
            NSString *leader = @"";
            if (self.selectedTransferDealerDictionary) {
                for (DMUserBookModel *user in [self.selectedTransferDealerDictionary allValues]) {
                    leader = user.userId;
                }
            }
            if ([leader isEqualToString:@""]) {
                requester.state = @([self getAgree]);
            } else {
                // 转批
                requester.state = @(4);
                requester.leaderId = leader;
            }
        } else {
            requester.state = @([self getAgree]);
        }
    } else if (taskOperator == TaskOperator_Rejected) {
        requester.state = @(ACTIVITI_STATE_REJECTED);
    } else if (taskOperator == TaskOperator_Finish) {
        requester.state = @(ACTIVITI_STATE_COMPLETE);
    } else if (taskOperator == TaskOperator_TransferComment) {
        requester.state = @(4);
        // 转批
        NSString *leader = @"";
        if (self.selectedTransferDealerDictionary) {
            for (DMUserBookModel *user in [self.selectedTransferDealerDictionary allValues]) {
                leader = user.userId;
            }
        }
        if ([leader isEqualToString:@""]) {
            showToast(@"请选择转批领导");
            return;
        }
        requester.leaderId = leader;
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

- (NSInteger)getAgree {
    if (self.activitiTaskModel) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BMLD] ||
            [self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_TJLD] ||
            [self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_BGSSP] ||
            [self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_JSY]) {
            return 1;
        }
    }
    return 2;
}

- (NSMutableArray *)dicArr {
    NSMutableArray *dicArr = [[NSMutableArray alloc] init];
    for (DMUserBookModel *mdl in self.driverList) {
        NSDictionary *dic = @{@"name":mdl.name,@"value":[NSString stringWithFormat:@"%@",mdl.userId]};
        [dicArr addObject:dic];
    }
    return dicArr;
}

- (NSMutableArray *)dicOfficialCarIdArr {
    NSMutableArray *dicArr = [[NSMutableArray alloc] init];
    for (DMOfficialCarModel *mdl in self.officialCarList) {
        NSDictionary *dic = @{@"name":mdl.state>0?[NSString stringWithFormat:@"%@ (外出)", mdl.number]:mdl.number,@"value":[NSString stringWithFormat:@"%@",mdl.ocId]};
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
