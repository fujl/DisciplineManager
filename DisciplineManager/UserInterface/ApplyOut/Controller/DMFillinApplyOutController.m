//
//  DMFillinApplyOutController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFillinApplyOutController.h"
#import "DMCommitApplyOutRequester.h"

@interface DMFillinApplyOutController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *outTimeTitleView;
@property (nonatomic, strong) DMEntrySelectView *outTimeView;
//@property (nonatomic, strong) DMEntryView *returnTimeTitleView;
//@property (nonatomic, strong) DMEntrySelectView *returnTimeView;
@property (nonatomic, strong) DMEntryView *outReasonTitleView;
@property (nonatomic, strong) DMMultiLineTextView *outReasonTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, assign) NSTimeInterval outTimeInterval;
@property (nonatomic, assign) NSTimeInterval returnTimeInterval;
@end

@implementation DMFillinApplyOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinApplyOut",@"填写外出申请单");
    [self.subviewList addObject:self.outTimeTitleView];
    [self.subviewList addObject:self.outTimeView];
//    [self.subviewList addObject:self.returnTimeTitleView];
//    [self.subviewList addObject:self.returnTimeView];
    [self.subviewList addObject:self.outReasonTitleView];
    [self.subviewList addObject:self.outReasonTextView];
    [self.subviewList addObject:self.commitView];
    [self addChildViews:self.subviewList];

    self.outTimeInterval = [[NSDate date] timeIntervalSince1970];
    self.returnTimeInterval = [[NSDate date] timeIntervalSince1970];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMEntryView *)outTimeTitleView {
    if (!_outTimeTitleView) {
        _outTimeTitleView = [[DMEntryView alloc] init];
        [_outTimeTitleView setTitle:NSLocalizedString(@"OutTime", @"外出时间")];
        _outTimeTitleView.lcHeight = 44;
    }
    return _outTimeTitleView;
}

- (DMEntrySelectView *)outTimeView {
    if (!_outTimeView) {
        _outTimeView = [[DMEntrySelectView alloc] init];
        _outTimeView.backgroundColor = [UIColor whiteColor];
        [_outTimeView setPlaceholder:NSLocalizedString(@"OutTimePlaceholder", @"必选，请选择外出时间")];
        _outTimeView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _outTimeView.clickEntryBlock = ^(NSString *value) {
            // 选择时间
            NSLog(@"选择时间");
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.outTimeInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            picker.datePicker.minimumDate = [NSDate date];
//            picker.datePicker.
            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
                weakSelf.outTimeInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
                weakSelf.outTimeView.value = [formatter stringFromDate:date];
            };
            [picker show];
        };
    }
    return _outTimeView;
}

//- (DMEntryView *)returnTimeTitleView {
//    if (!_returnTimeTitleView) {
//        _returnTimeTitleView = [[DMEntryView alloc] init];
//        [_returnTimeTitleView setTitle:NSLocalizedString(@"ReturnTime", @"回岗时间")];
//        _returnTimeTitleView.lcHeight = 44;
//    }
//    return _returnTimeTitleView;
//}
//
//- (DMEntrySelectView *)returnTimeView {
//    if (!_returnTimeView) {
//        _returnTimeView = [[DMEntrySelectView alloc] init];
//        _returnTimeView.backgroundColor = [UIColor whiteColor];
//        [_returnTimeView setPlaceholder:NSLocalizedString(@"ReturnTimePlaceholder", @"必选，请选择回岗时间")];
//        _returnTimeView.lcHeight = 44;
//        __weak typeof(self) weakSelf = self;
//        _returnTimeView.clickEntryBlock = ^(NSString *value) {
//            // 选择时间
//            NSLog(@"选择时间");
//            [AppWindow endEditing:YES];
//            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
//            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.returnTimeInterval];
//            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
//                weakSelf.returnTimeInterval = [date timeIntervalSince1970];
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
//                weakSelf.returnTimeView.value = [formatter stringFromDate:date];
//            };
//            [picker show];
//        };
//    }
//    return _returnTimeView;
//}

- (DMEntryView *)outReasonTitleView {
    if (!_outReasonTitleView) {
        _outReasonTitleView = [[DMEntryView alloc] init];
        [_outReasonTitleView setTitle:NSLocalizedString(@"OutReason", @"外出事由")];
        _outReasonTitleView.lcHeight = 44;
    }
    return _outReasonTitleView;
}

- (DMMultiLineTextView *)outReasonTextView {
    if (!_outReasonTextView) {
        _outReasonTextView = [[DMMultiLineTextView alloc] init];
        _outReasonTextView.lcHeight = 200;
        _outReasonTextView.backgroundColor = [UIColor whiteColor];
        [_outReasonTextView setPlaceholder:NSLocalizedString(@"OutReasonPlaceholder", @"必填，请输入外出事由")];
    }
    return _outReasonTextView;
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
    if ([self.outTimeView.value isEqualToString:@""]) {
        showToast(@"请选择外出时间");
        return;
    }
    if ([[self.outReasonTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入外出事由");
        return;
    }
    NSDate *outDt = [NSDate dateWithString:self.outTimeView.value format:@"yyyy年MM月dd日 HH时mm分"];
    NSTimeInterval outInterval = [outDt timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *dt = [NSDate dateWithTimeIntervalSince1970:outInterval];
    
    DMCommitApplyOutRequester *requester = [[DMCommitApplyOutRequester alloc] init];
    requester.startTime = [formatter stringFromDate:dt];
    requester.reason = [self.outReasonTextView getMultiLineText];
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
