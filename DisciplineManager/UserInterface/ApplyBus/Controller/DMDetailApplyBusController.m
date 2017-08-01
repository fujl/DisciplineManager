//
//  DMDetailApplyBusController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyBusController.h"
#import "DMDetailApplyBusRequester.h"
#import "DMApplyBusListInfo.h"
#import "DMTaskTracksView.h"
#import "DMSubmitTaskBusRequester.h"

@interface DMDetailApplyBusController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *outTimeView;
@property (nonatomic, strong) DMSingleView *driverNameView;
@property (nonatomic, strong) DMSingleView *officialCarView;
@property (nonatomic, strong) DMSingleView *returnTimeView;
@property (nonatomic, strong) DMEntryView *addressTitleView;
@property (nonatomic, strong) DMDetailView *addressDetailView;
@property (nonatomic, strong) DMEntryView *outReasonTitleView;
@property (nonatomic, strong) DMDetailView *outReasonDetailView;
@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;

@property (nonatomic, strong) DMApplyBusListInfo *info;

@end

@implementation DMDetailApplyBusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ApplyBus",@"公车申请"), NSLocalizedString(@"Detail",@"详情")];
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
                [self.userView setTitle:@"申请人" detail:self.activitiTaskModel.user.userInfo.name];
            }
            [self.outTimeView setTitle:NSLocalizedString(@"OutTime", @"外出时间") detail:self.info.startTime];
            if (self.activitiTaskModel) {
                if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyGCSQ_BGSSP]) {
                    [self.driverNameView setTitle:@"司机姓名" detail:self.info.driverName];
                    [self.officialCarView setTitle:@"车牌号码" detail:self.info.officialCar];
                }
            }
            
            NSString *returnTime = self.info.endTime && ![self.info.endTime isEqualToString:@""] ? self.info.endTime : @"未回岗";
            [self.returnTimeView setTitle:NSLocalizedString(@"ReturnTime", @"回岗时间") detail:returnTime];
            self.addressDetailView.lcHeight = [self.addressDetailView getHeightFromDetail:self.info.address];
            self.outReasonDetailView.lcHeight = [self.outReasonDetailView getHeightFromDetail:self.info.reason];
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
    
    [self.subviewList addObject:self.outTimeView];
    if (self.activitiTaskModel) {
        if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyGCSQ_BGSSP]) {
            [self.subviewList addObject:self.driverNameView];
            [self.subviewList addObject:self.officialCarView];
        }
    }
    
    [self.subviewList addObject:self.returnTimeView];
    
    [self.subviewList addObject:self.addressTitleView];
    [self.subviewList addObject:self.addressDetailView];
    
    [self.subviewList addObject:self.outReasonTitleView];
    [self.subviewList addObject:self.outReasonDetailView];
    
    if (self.activitiTaskModel) {
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

- (DMSingleView *)outTimeView {
    if (!_outTimeView) {
        _outTimeView = [[DMSingleView alloc] init];
        _outTimeView.lcHeight = 44;
    }
    return _outTimeView;
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

- (DMSingleView *)returnTimeView {
    if (!_returnTimeView) {
        _returnTimeView = [[DMSingleView alloc] init];
        _returnTimeView.lcHeight = 44;
    }
    return _returnTimeView;
}
- (DMEntryView *)addressTitleView {
    if (!_addressTitleView) {
        _addressTitleView = [[DMEntryView alloc] init];
        [_addressTitleView setTitle:@"外出地址"];
        _addressTitleView.lcHeight = 44;
    }
    return _addressTitleView;
}

- (DMDetailView *)addressDetailView {
    if (!_addressDetailView) {
        _addressDetailView = [[DMDetailView alloc] init];
    }
    return _addressDetailView;
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
    DMDetailApplyBusRequester *requester = [[DMDetailApplyBusRequester alloc] init];
    requester.abId = self.abId;
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
- (void)submitTask:(DMTaskOperator)taskOperator {
    if ([[self.commentTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入批注");
        return;
    }
    DMSubmitTaskBusRequester *requester = [[DMSubmitTaskBusRequester alloc] init];
    requester.businessId = self.abId;
    requester.taskId = self.activitiTaskModel.atId;
    requester.message = [self.commentTextView getMultiLineText];
    if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyGCSQ_BGSSP]) {
        
    } else if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyGCSQ_SJLD]) {
        requester.emp = @"BGSZR";
    } else {
        
    }
    if (taskOperator == TaskOperator_Agree) {
        requester.state = ACTIVITI_STATE_COMPLETE;
    } else if (taskOperator == TaskOperator_Rejected) {
        requester.state = ACTIVITI_STATE_REJECTED;
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
