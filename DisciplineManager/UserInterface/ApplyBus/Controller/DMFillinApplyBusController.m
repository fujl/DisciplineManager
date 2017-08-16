//
//  DMFillinApplyBusController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/17.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFillinApplyBusController.h"
#import "DMAddressManager.h"
#import "DMAddressPickerView.h"
#import "DMCommitApplyBusRequester.h"

@interface DMFillinApplyBusController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *outTimeTitleView;
@property (nonatomic, strong) DMEntrySelectView *outTimeView;
@property (nonatomic, strong) DMEntryView *outAddressTitleView;
@property (nonatomic, strong) DMEntrySelectView *outAddressView;
@property (nonatomic, strong) DMEntryView *outDetailAddressTitleView;
@property (nonatomic, strong) DMSingleTextView *outDetailAddressView;
@property (nonatomic, strong) DMEntryView *outReasonTitleView;
@property (nonatomic, strong) DMMultiLineTextView *outReasonTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;
@property (nonatomic, assign) NSTimeInterval outTimeInterval;

@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger areaId;
@end

@implementation DMFillinApplyBusController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.provinceId = 2585;
        self.cityId = 2644;
        self.areaId = 2645;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinApplyBus",@"填写公车申请单");
    [self.subviewList addObject:self.outTimeTitleView];
    [self.subviewList addObject:self.outTimeView];
    [self.subviewList addObject:self.outAddressTitleView];
    [self.subviewList addObject:self.outAddressView];
    [self.subviewList addObject:self.outDetailAddressTitleView];
    [self.subviewList addObject:self.outDetailAddressView];
    [self.subviewList addObject:self.outReasonTitleView];
    [self.subviewList addObject:self.outReasonTextView];
    [self.subviewList addObject:self.commitView];
    [self addChildViews:self.subviewList];
    
    self.outTimeInterval = [[NSDate date] timeIntervalSince1970];
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

- (DMEntryView *)outAddressTitleView {
    if (!_outAddressTitleView) {
        _outAddressTitleView = [[DMEntryView alloc] init];
        [_outAddressTitleView setTitle:NSLocalizedString(@"OutAddress", @"外出地址")];
        _outAddressTitleView.lcHeight = 44;
    }
    return _outAddressTitleView;
}

- (DMEntrySelectView *)outAddressView {
    if (!_outAddressView) {
        _outAddressView = [[DMEntrySelectView alloc] init];
        _outAddressView.backgroundColor = [UIColor whiteColor];
        [_outAddressView setPlaceholder:NSLocalizedString(@"OutAddressPlaceholder", @"必选，请选择外出地址")];
        _outAddressView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _outAddressView.clickEntryBlock = ^(NSString *value) {
            [AppWindow endEditing:YES];
            DMAddressManager *manager = getManager([DMAddressManager class]);
            showLoadingDialog();
            [manager getAllAddress:^(NSMutableArray<DMAddressInfo *> *addressList) {
                dismissLoadingDialog();
                DMAddressPickerView *pickerView = [[DMAddressPickerView alloc] init];
                if (weakSelf.provinceId > 0 && weakSelf.cityId > 0 && weakSelf.areaId > 0) {
                    [pickerView selected:weakSelf.provinceId city:weakSelf.cityId area:weakSelf.areaId];
                }
                [pickerView refreshData];
                
                pickerView.onCompleteClick = ^(DMAddressInfo *provinceInfo, DMAddressInfo *cityInfo, DMAddressInfo *areaInfo) {
                    weakSelf.provinceId = provinceInfo.addressId;
                    weakSelf.cityId = cityInfo.addressId;
                    weakSelf.areaId = areaInfo.addressId;
                    [weakSelf.outAddressView setValue:[NSString stringWithFormat:@"%@, %@, %@", provinceInfo.name, cityInfo.name, areaInfo.name]];
                };
                
                [pickerView show];
            }];
        };
    }
    return _outAddressView;
}

- (DMEntryView *)outDetailAddressTitleView {
    if (!_outDetailAddressTitleView) {
        _outDetailAddressTitleView = [[DMEntryView alloc] init];
        [_outDetailAddressTitleView setTitle:NSLocalizedString(@"OutDetailAddress", @"外出详细地址")];
        _outDetailAddressTitleView.lcHeight = 44;
    }
    return _outDetailAddressTitleView;
}

- (DMSingleTextView *)outDetailAddressView {
    if (!_outDetailAddressView) {
        _outDetailAddressView = [[DMSingleTextView alloc] init];
        _outDetailAddressView.lcHeight = 44;
        _outDetailAddressView.backgroundColor = [UIColor whiteColor];
        [_outDetailAddressView setPlaceholder:NSLocalizedString(@"DetailAddressPlaceholder", @"必填，请输入详细地址")];
    }
    return _outDetailAddressView;
}

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
    if ([self.outAddressView.value isEqualToString:@""]) {
        showToast(@"请选择外出地址");
        return;
    }
    if ([[self.outDetailAddressView getSingleText] isEqualToString:@""]) {
        showToast(@"请输入外出详细地址");
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
    
    DMCommitApplyBusRequester *requester = [[DMCommitApplyBusRequester alloc] init];
    requester.startTime = [formatter stringFromDate:dt];
    requester.address = [NSString stringWithFormat:@"%@, %@", self.outAddressView.value, [self.outDetailAddressView getSingleText]];
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
