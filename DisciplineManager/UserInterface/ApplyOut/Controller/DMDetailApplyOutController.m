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

@interface DMDetailApplyOutController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMSingleView *userView;
@property (nonatomic, strong) DMSingleView *stateView;
@property (nonatomic, strong) DMSingleView *outTimeView;
@property (nonatomic, strong) DMSingleView *returnTimeView;
@property (nonatomic, strong) DMEntryView *outReasonTitleView;
@property (nonatomic, strong) DMDetailView *outReasonDetailView;

@property (nonatomic, strong) DMTaskTracksView *taskTracksView;

@property (nonatomic, strong) DMEntryView *commentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *commentTextView;
@property (nonatomic, strong) DMTaskOperatorView *taskOperatorView;

@property (nonatomic, strong) DMApplyOutListInfo *info;
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
            self.outReasonDetailView.lcHeight = [self.outReasonDetailView getHeightFromDetail:self.info.reason];
            if (self.activitiTaskModel) {
                if ([self.activitiTaskModel.definitionKey isEqualToString:kDefinitionKeyWCSQ_SJLD]) {
                    [self.taskOperatorView refreshView:NO];
                } else {
                    [self.taskOperatorView refreshFinishHuigangView];
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
    DMDetailApplyOutRequester *requester = [[DMDetailApplyOutRequester alloc] init];
    requester.aoId = self.aoId;
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
    DMSubmitTaskOutRequester *requester = [[DMSubmitTaskOutRequester alloc] init];
    requester.businessId = self.aoId;
    requester.taskId = self.activitiTaskModel.atId;
    requester.message = [self.commentTextView getMultiLineText];
    
    if (taskOperator == TaskOperator_Agree) {
        requester.state = @(3);
    } else if (taskOperator == TaskOperator_Rejected) {
        requester.state = @(ACTIVITI_STATE_REJECTED);
    } else if (taskOperator == TaskOperator_Finish) {
        requester.state = @(ACTIVITI_STATE_COMPLETE);
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
