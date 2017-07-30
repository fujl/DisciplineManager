//
//  DMFillinApplyCompensatoryController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/23.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFillinApplyCompensatoryController.h"
#import "DMCommitApplyCompensatoryRequester.h"

@interface DMFillinApplyCompensatoryController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *startOvertimeTitleView;
@property (nonatomic, strong) DMEntrySelectView *startOvertimeView;
@property (nonatomic, strong) DMEntryView *endOvertimeTitleView;
@property (nonatomic, strong) DMEntrySelectView *endOvertimeView;
@property (nonatomic, strong) DMEntryView *overtimeReasonTitleView;
@property (nonatomic, strong) DMMultiLineTextView *overtimeReasonTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, assign) NSTimeInterval startOvertimeInterval;
@property (nonatomic, assign) NSTimeInterval endOvertimeInterval;
@end

@implementation DMFillinApplyCompensatoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinApplyCompensatory", @"填写补休申请单");
    [self.subviewList addObject:self.startOvertimeTitleView];
    [self.subviewList addObject:self.startOvertimeView];
    [self.subviewList addObject:self.endOvertimeTitleView];
    [self.subviewList addObject:self.endOvertimeView];
    [self.subviewList addObject:self.overtimeReasonTitleView];
    [self.subviewList addObject:self.overtimeReasonTextView];
    [self.subviewList addObject:self.commitView];
    [self addChildViews:self.subviewList];
    
    self.startOvertimeInterval = [[NSDate date] timeIntervalSince1970];
    self.endOvertimeInterval = [[NSDate date] timeIntervalSince1970];
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

- (DMEntrySelectView *)startOvertimeView {
    if (!_startOvertimeView) {
        _startOvertimeView = [[DMEntrySelectView alloc] init];
        _startOvertimeView.backgroundColor = [UIColor whiteColor];
        [_startOvertimeView setPlaceholder:NSLocalizedString(@"StartOvertimePlaceholder", @"必选，请选择加班开始时间")];
        _startOvertimeView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _startOvertimeView.clickEntryBlock = ^(NSString *value) {
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.startOvertimeInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            NSDate *maxDt = [NSDate date];
            NSTimeInterval maxInterval = [maxDt timeIntervalSince1970];
            NSDate *minDt = [NSDate dateWithTimeIntervalSince1970:maxInterval-7*24*60*60];
            picker.datePicker.minimumDate = minDt;
            picker.datePicker.maximumDate = maxDt;
            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
                weakSelf.startOvertimeInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
                weakSelf.startOvertimeView.value = [formatter stringFromDate:date];
            };
            [picker show];
        };
    }
    return _startOvertimeView;
}
- (DMEntryView *)endOvertimeTitleView {
    if (!_endOvertimeTitleView) {
        _endOvertimeTitleView = [[DMEntryView alloc] init];
        [_endOvertimeTitleView setTitle:NSLocalizedString(@"EndOvertime", @"加班结束时间")];
        _endOvertimeTitleView.lcHeight = 44;
    }
    return _endOvertimeTitleView;
}

- (DMEntrySelectView *)endOvertimeView {
    if (!_endOvertimeView) {
        _endOvertimeView = [[DMEntrySelectView alloc] init];
        _endOvertimeView.backgroundColor = [UIColor whiteColor];
        [_endOvertimeView setPlaceholder:NSLocalizedString(@"EndOvertimePlaceholder", @"必选，请选择加班结束时间")];
        _endOvertimeView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _endOvertimeView.clickEntryBlock = ^(NSString *value) {
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.endOvertimeInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            NSDate *maxDt = [NSDate date];
            NSTimeInterval maxInterval = [maxDt timeIntervalSince1970];
            NSDate *minDt = [NSDate dateWithTimeIntervalSince1970:maxInterval-7*24*60*60];
            picker.datePicker.minimumDate = minDt;
            picker.datePicker.maximumDate = maxDt;
            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
                weakSelf.endOvertimeInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
                weakSelf.endOvertimeView.value = [formatter stringFromDate:date];
            };
            [picker show];
        };
    }
    return _endOvertimeView;
}

- (DMEntryView *)overtimeReasonTitleView {
    if (!_overtimeReasonTitleView) {
        _overtimeReasonTitleView = [[DMEntryView alloc] init];
        [_overtimeReasonTitleView setTitle:NSLocalizedString(@"OvertimeReason", @"加班事由")];
        _overtimeReasonTitleView.lcHeight = 44;
    }
    return _overtimeReasonTitleView;
}

- (DMMultiLineTextView *)overtimeReasonTextView {
    if (!_overtimeReasonTextView) {
        _overtimeReasonTextView = [[DMMultiLineTextView alloc] init];
        _overtimeReasonTextView.lcHeight = 200;
        _overtimeReasonTextView.backgroundColor = [UIColor whiteColor];
        [_overtimeReasonTextView setPlaceholder:NSLocalizedString(@"OvertimeReasonPlaceholder", @"必填，请输入加班事由")];
    }
    return _overtimeReasonTextView;
}

- (DMEntryCommitView *)commitView {
    if (!_commitView) {
        _commitView = [[DMEntryCommitView alloc] init];
        _commitView.lcHeight = 64;
        __weak typeof(self) weakSelf = self;
        _commitView.clickCommitBlock = ^{
            NSLog(@"commit");
            [AppWindow endEditing:YES];
            [weakSelf commitData];
        };
    }
    return _commitView;
}

- (void)commitData {
    if ([self.startOvertimeView.value isEqualToString:@""]) {
        showToast(@"请选择加班开始时间");
        return;
    }
    if ([self.endOvertimeView.value isEqualToString:@""]) {
        showToast(@"请选择加班结束地址");
        return;
    }
    if ([[self.overtimeReasonTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入加班事由");
        return;
    }
    NSDate *startDt = [NSDate dateWithString:self.startOvertimeView.value format:@"yyyy年MM月dd日 HH时mm分"];
    NSTimeInterval startInterval = [startDt timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startIntervalDt = [NSDate dateWithTimeIntervalSince1970:startInterval];
    
    NSDate *endDt = [NSDate dateWithString:self.endOvertimeView.value format:@"yyyy年MM月dd日 HH时mm分"];
    NSTimeInterval endInterval = [endDt timeIntervalSince1970];
    NSDate *endIntervalDt = [NSDate dateWithTimeIntervalSince1970:endInterval];
    
    DMCommitApplyCompensatoryRequester *requester = [[DMCommitApplyCompensatoryRequester alloc] init];
    requester.startTime = [formatter stringFromDate:startIntervalDt];
    requester.endTime = [formatter stringFromDate:endIntervalDt];
    requester.reason = [self.overtimeReasonTextView getMultiLineText];
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}
@end
