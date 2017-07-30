//
//  DMDetailApplyCompensatoryController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyCompensatoryController.h"
#import "DMDetailApplyCompensatoryRequester.h"

@interface DMDetailApplyCompensatoryController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *startOvertimeTitleView;
@property (nonatomic, strong) DMDetailView *startOvertimeDetailView;
@property (nonatomic, strong) DMEntryView *endOvertimeTitleView;
@property (nonatomic, strong) DMDetailView *endOvertimeDetailView;
@property (nonatomic, strong) DMEntryView *overtimeReasonTitleView;
@property (nonatomic, strong) DMDetailView *overtimeReasonDetailView;

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
            DMApplyCompensatoryListInfo *info = data;
            self.startOvertimeDetailView.lcHeight = [self.startOvertimeDetailView getHeightFromDetail:info.startTime];
            self.endOvertimeDetailView.lcHeight = [self.endOvertimeDetailView getHeightFromDetail:info.endTime];
            self.overtimeReasonDetailView.lcHeight = [self.overtimeReasonDetailView getHeightFromDetail:info.reason];
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
    
    [self.subviewList addObject:self.startOvertimeTitleView];
    [self.subviewList addObject:self.startOvertimeDetailView];
    
    [self.subviewList addObject:self.endOvertimeTitleView];
    [self.subviewList addObject:self.endOvertimeDetailView];
    
    [self.subviewList addObject:self.overtimeReasonTitleView];
    [self.subviewList addObject:self.overtimeReasonDetailView];
    
    [self setChildViews:self.subviewList];
}


#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMEntryView *)startOvertimeTitleView {
    if (!_startOvertimeTitleView) {
        _startOvertimeTitleView = [[DMEntryView alloc] init];
        [_startOvertimeTitleView setTitle:NSLocalizedString(@"StartOvertime", @"加班开始时间")];
        _startOvertimeTitleView.lcHeight = 44;
    }
    return _startOvertimeTitleView;
}

- (DMDetailView *)startOvertimeDetailView {
    if (!_startOvertimeDetailView) {
        _startOvertimeDetailView = [[DMDetailView alloc] init];
    }
    return _startOvertimeDetailView;
}

- (DMEntryView *)endOvertimeTitleView {
    if (!_endOvertimeTitleView) {
        _endOvertimeTitleView = [[DMEntryView alloc] init];
        [_endOvertimeTitleView setTitle:NSLocalizedString(@"EndOvertime", @"加班结束时间")];
        _endOvertimeTitleView.lcHeight = 44;
    }
    return _endOvertimeTitleView;
}

- (DMDetailView *)endOvertimeDetailView {
    if (!_endOvertimeDetailView) {
        _endOvertimeDetailView = [[DMDetailView alloc] init];
    }
    return _endOvertimeDetailView;
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

@end
