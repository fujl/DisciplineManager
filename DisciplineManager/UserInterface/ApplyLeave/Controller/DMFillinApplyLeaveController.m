//
//  DMFillinApplyLeaveController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/23.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFillinApplyLeaveController.h"
#import "DMFindHolidayRequester.h"
#import "DMLeaveTicketViewController.h"
#import "DMCommitApplyLeaveRequester.h"

@interface DMFillinApplyLeaveController () <UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *leaveTypeTitleView;
@property (nonatomic, strong) DMEntrySelectView *leaveTypeView;
@property (nonatomic, strong) DMEntryView *startTimeTitleView;
@property (nonatomic, strong) DMEntrySelectView *startTimeView;
@property (nonatomic, strong) DMEntryView *endTimeTitleView;
@property (nonatomic, strong) DMEntrySelectView *endTimeView;
@property (nonatomic, strong) DMEntryView *actualLeaveNumberTitleView;
@property (nonatomic, strong) DMDetailView *actualLeaveNumberView;
@property (nonatomic, strong) DMEntryView *holidaysTitleView;
@property (nonatomic, strong) DMDetailView *holidaysView;
@property (nonatomic, strong) DMEntryView *leaveTicketNumberTitleView;
@property (nonatomic, strong) DMEntrySelectView *leaveTicketNumberView;
@property (nonatomic, strong) DMEntryView *leaveReasonTitleView;
@property (nonatomic, strong) DMMultiLineTextView *leaveReasonTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, assign) DMLeaveType type;
@property (nonatomic, assign) NSTimeInterval startTimeInterval;
@property (nonatomic, assign) NSTimeInterval endTimeInterval;
@property (nonatomic, assign) DMDateType startDateType;
@property (nonatomic, assign) DMDateType endDateType;
@property (nonatomic, strong) NSMutableArray *holidayList;
@property (nonatomic, strong) NSMutableArray *holidayStringList;
@property (nonatomic, strong) NSMutableArray<DMLeaveTicketModel *> *leaveTickets;
@property (nonatomic, assign) CGFloat leaveTicketDays;

@end

@implementation DMFillinApplyLeaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinApplyLeave",@"填写请(休)假申请单");
    [self refreshView];
    
    [self initData];
}

- (void)refreshView {
    [self.subviewList removeAllObjects];
    [self.subviewList addObject:self.leaveTypeTitleView];
    [self.subviewList addObject:self.leaveTypeView];
    [self.subviewList addObject:self.startTimeTitleView];
    [self.subviewList addObject:self.startTimeView];
    [self.subviewList addObject:self.endTimeTitleView];
    [self.subviewList addObject:self.endTimeView];
    [self.subviewList addObject:self.actualLeaveNumberTitleView];
    [self.subviewList addObject:self.actualLeaveNumberView];
    [self.subviewList addObject:self.holidaysTitleView];
    [self.subviewList addObject:self.holidaysView];
    if (self.type == LeaveTypeVacation) {
        [self.subviewList addObject:self.leaveTicketNumberTitleView];
        [self.subviewList addObject:self.leaveTicketNumberView];
    }
    [self.subviewList addObject:self.leaveReasonTitleView];
    [self.subviewList addObject:self.leaveReasonTextView];
    [self.subviewList addObject:self.commitView];
    [self setChildViews:self.subviewList];
}

- (void)initData {
    self.type = LeaveTypeNone;
    self.startTimeInterval = [[NSDate date] timeIntervalSince1970];
    self.endTimeInterval = [[NSDate date] timeIntervalSince1970];
    self.startDateType = DMDateTypeMorning;
    self.endDateType = DMDateTypeMorning;
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMEntryView *)leaveTypeTitleView {
    if (!_leaveTypeTitleView) {
        _leaveTypeTitleView = [[DMEntryView alloc] init];
        [_leaveTypeTitleView setTitle:NSLocalizedString(@"LeaveType", @"请(休)假类别")];
        _leaveTypeTitleView.lcHeight = 44;
    }
    return _leaveTypeTitleView;
}

- (DMEntrySelectView *)leaveTypeView {
    if (!_leaveTypeView) {
        _leaveTypeView = [[DMEntrySelectView alloc] init];
        _leaveTypeView.backgroundColor = [UIColor whiteColor];
        [_leaveTypeView setPlaceholder:NSLocalizedString(@"LeaveTypePlaceholder", @"必选，当选择请假时，无需选择休假票")];
        _leaveTypeView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _leaveTypeView.clickEntryBlock = ^(NSString *value) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Leave", nil), NSLocalizedString(@"Vacation", nil), nil];
            [actionSheet showInView:weakSelf.view];
        };
    }
    return _leaveTypeView;
}

- (DMEntryView *)startTimeTitleView {
    if (!_startTimeTitleView) {
        _startTimeTitleView = [[DMEntryView alloc] init];
        [_startTimeTitleView setTitle:NSLocalizedString(@"StartTime", @"开始时间")];
        _startTimeTitleView.lcHeight = 44;
    }
    return _startTimeTitleView;
}

- (DMEntrySelectView *)startTimeView {
    if (!_startTimeView) {
        _startTimeView = [[DMEntrySelectView alloc] init];
        _startTimeView.backgroundColor = [UIColor whiteColor];
        [_startTimeView setPlaceholder:NSLocalizedString(@"StartTimePlaceholder", @"必选，请选择开始时间")];
        _startTimeView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _startTimeView.clickEntryBlock = ^(NSString *value) {
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] initWithDateType:weakSelf.startDateType];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.startTimeInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDate;
            picker.datePicker.minimumDate = [NSDate date];
            picker.onCompleteDtClick = ^(DMDatePickerView *datePicker, NSDate *date, DMDateTypeModel *dtModel) {
                weakSelf.startTimeInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日";
                weakSelf.startDateType = dtModel.dateType;
                weakSelf.startTimeView.value = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:date], dtModel.name];
                
                [weakSelf refreshHolidays];
            };
            [picker show];
        };
    }
    return _startTimeView;
}
- (DMEntryView *)endTimeTitleView {
    if (!_endTimeTitleView) {
        _endTimeTitleView = [[DMEntryView alloc] init];
        [_endTimeTitleView setTitle:NSLocalizedString(@"EndTime", @"结束时间")];
        _endTimeTitleView.lcHeight = 44;
    }
    return _endTimeTitleView;
}

- (DMEntrySelectView *)endTimeView {
    if (!_endTimeView) {
        _endTimeView = [[DMEntrySelectView alloc] init];
        _endTimeView.backgroundColor = [UIColor whiteColor];
        [_endTimeView setPlaceholder:NSLocalizedString(@"EndTimePlaceholder", @"必选，请选择结束时间")];
        _endTimeView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _endTimeView.clickEntryBlock = ^(NSString *value) {
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] initWithDateType:weakSelf.endDateType];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.endTimeInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDate;
            picker.datePicker.minimumDate = [NSDate date];
            picker.onCompleteDtClick = ^(DMDatePickerView *datePicker, NSDate *date, DMDateTypeModel *dtModel) {
                weakSelf.endTimeInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日";
                weakSelf.endDateType = dtModel.dateType;
                weakSelf.endTimeView.value = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:date], dtModel.name];
                
                [weakSelf refreshHolidays];
            };
            [picker show];
        };
    }
    return _endTimeView;
}

- (DMEntryView *)actualLeaveNumberTitleView {
    if (!_actualLeaveNumberTitleView) {
        _actualLeaveNumberTitleView = [[DMEntryView alloc] init];
        [_actualLeaveNumberTitleView setTitle:NSLocalizedString(@"ActualLeaveNumber", @"实际请(休)假天数")];
        _actualLeaveNumberTitleView.lcHeight = 44;
    }
    return _actualLeaveNumberTitleView;
}

- (DMDetailView *)actualLeaveNumberView {
    if (!_actualLeaveNumberView) {
        _actualLeaveNumberView = [[DMDetailView alloc] init];
        _actualLeaveNumberView.backgroundColor = [UIColor whiteColor];
        _actualLeaveNumberView.lcHeight = [_actualLeaveNumberView getHeightFromPlaceholder:NSLocalizedString(@"ActualLeaveNumberPlaceholder", @"请假天数由系统计算完成，此天数不包含节假日")];
    }
    return _actualLeaveNumberView;
}

- (DMEntryView *)holidaysTitleView {
    if (!_holidaysTitleView) {
        _holidaysTitleView = [[DMEntryView alloc] init];
        [_holidaysTitleView setTitle:NSLocalizedString(@"Holidays", @"节假日")];
        _holidaysTitleView.lcHeight = 44;
    }
    return _holidaysTitleView;
}

- (DMDetailView *)holidaysView {
    if (!_holidaysView) {
        _holidaysView = [[DMDetailView alloc] init];
        _holidaysView.backgroundColor = [UIColor whiteColor];
        _holidaysView.lcHeight = [_holidaysView getHeightFromPlaceholder:NSLocalizedString(@"HolidaysPlaceholder", @"系统计算的节假日天数")];
    }
    return _holidaysView;
}

- (DMEntryView *)leaveTicketNumberTitleView {
    if (!_leaveTicketNumberTitleView) {
        _leaveTicketNumberTitleView = [[DMEntryView alloc] init];
        [_leaveTicketNumberTitleView setTitle:NSLocalizedString(@"LeaveTicketNumber", @"请(休)假票天数")];
        _leaveTicketNumberTitleView.lcHeight = 44;
    }
    return _leaveTicketNumberTitleView;
}

- (DMEntrySelectView *)leaveTicketNumberView {
    if (!_leaveTicketNumberView) {
        _leaveTicketNumberView = [[DMEntrySelectView alloc] init];
        _leaveTicketNumberView.backgroundColor = [UIColor whiteColor];
        [_leaveTicketNumberView setPlaceholder:NSLocalizedString(@"LeaveTicketNumberPlaceholder", @"必选，请选择休假票")];
        _leaveTicketNumberView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _leaveTicketNumberView.clickEntryBlock = ^(NSString *value) {
            DMLeaveTicketViewController *controller = [[DMLeaveTicketViewController alloc] init];
            controller.selectedLeaveTicketBlock = ^(NSMutableArray<DMLeaveTicketModel *> *leaveTickets) {
                weakSelf.leaveTickets = leaveTickets;
                weakSelf.leaveTicketDays = 0;
                for (DMLeaveTicketModel *mdl in leaveTickets) {
                    weakSelf.leaveTicketDays += mdl.days;
                }
                weakSelf.leaveTicketNumberView.value = [NSString stringWithFormat:@"%0.1f", weakSelf.leaveTicketDays];
            };
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    }
    return _leaveTicketNumberView;
}

- (DMEntryView *)leaveReasonTitleView {
    if (!_leaveReasonTitleView) {
        _leaveReasonTitleView = [[DMEntryView alloc] init];
        [_leaveReasonTitleView setTitle:NSLocalizedString(@"LeaveReason", @"请(休)假事由")];
        _leaveReasonTitleView.lcHeight = 44;
    }
    return _leaveReasonTitleView;
}

- (DMMultiLineTextView *)leaveReasonTextView {
    if (!_leaveReasonTextView) {
        _leaveReasonTextView = [[DMMultiLineTextView alloc] init];
        _leaveReasonTextView.lcHeight = 200;
        _leaveReasonTextView.backgroundColor = [UIColor whiteColor];
        [_leaveReasonTextView setPlaceholder:NSLocalizedString(@"LeaveReasonPlaceholder", @"必填，请输入请(休)假事由")];
    }
    return _leaveReasonTextView;
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

- (NSMutableArray *)holidayList {
    if (!_holidayList) {
        _holidayList = [[NSMutableArray alloc] init];
    }
    return _holidayList;
}

- (NSMutableArray *)holidayStringList {
    if (!_holidayStringList) {
        _holidayStringList = [[NSMutableArray alloc] init];
    }
    return _holidayStringList;
}

#pragma mark - 刷新数据
- (void)refreshHolidays {
    if ([self.startTimeView.value isEqualToString:@""]) {
        return;
    }
    if ([self.endTimeView.value isEqualToString:@""]) {
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *startDt = [NSDate dateWithTimeIntervalSince1970:self.startTimeInterval];
    NSDate *endDt = [NSDate dateWithTimeIntervalSince1970:self.endTimeInterval];
    
    DMFindHolidayRequester *requester = [[DMFindHolidayRequester alloc] init];
    requester.startDate = [formatter stringFromDate:startDt];
    requester.endDate = [formatter stringFromDate:endDt];
    
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, NSArray *holidayArray) {
        dismissLoadingDialog();
        [self.holidayList removeAllObjects];
        if (code == ResultCodeOK) {
            [self.holidayStringList removeAllObjects];
            if (holidayArray) {
                [self.holidayList addObjectsFromArray:holidayArray];
            }
            if (self.holidayList.count > 0) {
                NSString *holiday = @"";
                for (NSDictionary *holidayDic in self.holidayList) {
                    NSString *holidayString = [holidayDic objectForKey:@"startDate"];
                    [self.holidayStringList addObject:holidayString];
                    if ([holiday isEqualToString:@""]) {
                        holiday = holidayString;
                    } else {
                        holiday = [NSString stringWithFormat:@"%@,%@", holiday, holidayString];
                    }
                }
                self.holidaysView.lcHeight = [self.holidaysView getHeightFromDetail:holiday];
            }
            [self calculationDays];
        }
    }];
}

#pragma mark - private method
- (void)calculationDays {
    // 判断开始时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSDate *startDt = [NSDate dateWithTimeIntervalSince1970:self.startTimeInterval];
    NSString *startDate = [formatter stringFromDate:startDt];
    NSDate *endDt = [NSDate dateWithTimeIntervalSince1970:self.endTimeInterval];
    NSString *endDate = [formatter stringFromDate:endDt];
    
    CGFloat fday = 0;
    
    NSInteger holiday = self.holidayStringList.count;
    
    if (![startDate isEqualToString:endDate]) {
        NSInteger day = [self getDayFromTimeInterval:[[NSDate dateWithString:startDate format:@"yyyyMMdd"] timeIntervalSince1970] endday:[[NSDate dateWithString:endDate format:@"yyyyMMdd"] timeIntervalSince1970]]-1;
        
        if (holiday > 0) {
            if ([self isHolidayFromDt:startDate]) {
                holiday--;
            } else {
                if (self.startDateType == DMDateTypeMorning) {
                    fday += 1;
                } else {
                    fday += 0.5;
                }
            }
            if ([self isHolidayFromDt:endDate]) {
                holiday--;
            } else {
                if (self.endDateType == DMDateTypeMorning) {
                    fday += 0.5;
                } else {
                    fday += 1;
                }
            }
        } else {
            if (self.startDateType == DMDateTypeMorning) {
                fday += 1;
            } else {
                fday += 0.5;
            }
            if (self.endDateType == DMDateTypeMorning) {
                fday += 0.5;
            } else {
                fday += 1;
            }
        }
        
        if (day > 0) {
            fday += day;
        }
        if (holiday > 0) {
            fday -= holiday;
        }
    } else {
        if (holiday > 0) {
            fday = 0;
        } else {
            if (self.startDateType == DMDateTypeMorning && self.endDateType == DMDateTypeMorning) {
                fday = 0.5;
            } else if (self.startDateType == DMDateTypeMorning && self.endDateType == DMDateTypeAfternoon) {
                fday = 1;
            } else if (self.startDateType == DMDateTypeAfternoon && self.endDateType == DMDateTypeAfternoon) {
                fday = 0.5;
            }
        }
    }
    self.actualLeaveNumberView.lcHeight = [self.actualLeaveNumberView getHeightFromDetail:[NSString stringWithFormat:@"%0.1f", fday]];
}

- (BOOL)isHolidayFromDt:(NSString *)holiday {
    BOOL isHoliday = NO;
    for (NSString *holidayString in self.holidayStringList) {
        if ([holidayString isEqualToString:holiday]) {
            isHoliday = YES;
            break;
        }
    }
    return isHoliday;
}

- (NSInteger)getDayFromTimeInterval:(NSTimeInterval)startday endday:(NSTimeInterval)endday {
    NSDate *startDt = [NSDate dateWithTimeIntervalSince1970:startday];
    NSDate *endDt = [NSDate dateWithTimeIntervalSince1970:endday];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDt toDate:endDt options:0];
    NSInteger day = [components day];
    return day;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.type = LeaveTypeDefault;
            self.leaveTypeView.value = NSLocalizedString(@"Leave", nil);
            [self refreshView];
            break;
        case 1:
            self.type = LeaveTypeVacation;
            self.leaveTypeView.value = NSLocalizedString(@"Vacation", nil);
            [self refreshView];
            break;
        default:
            break;
    }
}

#pragma mark - commit
- (void)commitData {
    if (self.type == LeaveTypeNone) {
        showToast(@"请选择请(休)假类别");
        return;
    }
    if ([self.startTimeView.value isEqualToString:@""]) {
        showToast(@"请选择开始时间");
        return;
    }
    if ([self.endTimeView.value isEqualToString:@""]) {
        showToast(@"请选择结束时间");
        return;
    }
    if ([[self.leaveReasonTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入请(休)假事由");
        return;
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *startdt = [NSDate dateWithTimeIntervalSince1970:self.startTimeInterval];
    NSDate *enddt = [NSDate dateWithTimeIntervalSince1970:self.endTimeInterval];
    
    DMCommitApplyLeaveRequester *requester = [[DMCommitApplyLeaveRequester alloc] init];
    requester.type = self.type;
    requester.startTime = [formatter stringFromDate:startdt];
    requester.startTimeType = self.startDateType;
    requester.endTime = [formatter stringFromDate:enddt];
    requester.endTimeType = self.endDateType;
    if (self.holidayList.count > 0) {
        requester.holiday = self.holidaysView.detail;
    }
    requester.days = [self.actualLeaveNumberView.detail floatValue];
    requester.reason = [self.leaveReasonTextView getMultiLineText];
    if (self.type == LeaveTypeVacation) {
        requester.ticket = self.leaveTicketNumberView.value;
    }
    
    if (self.type == LeaveTypeVacation) {
        if (self.leaveTickets.count > 0) {
            if (self.leaveTicketDays < requester.days) {
                NSString *show = [NSString stringWithFormat:@"休假票天数为：%0.1f天, 实际请假天数为：%0.1f天, 请重新选择", self.leaveTicketDays, requester.days];
                showToast(show);
                return;
            } else if (self.leaveTicketDays > requester.days) {
                NSString *message = @"您所选择的休假票天数大于请假天数，是否确定使用？";
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
                return;
            }
        } else {
            showToast(@"请选择休假票");
            return;
        }
    }
    
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
