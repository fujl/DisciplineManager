//
//  DMSuperviseFillinController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviseFillinController.h"
#import "DMSelectUserController.h"
#import "DMUserBookModel.h"
#import "DMSuperviseSubmitRequester.h"

@interface DMSuperviseFillinController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *deadlineTitleView;
@property (nonatomic, strong) DMEntrySelectView *deadlineView;

@property (nonatomic, strong) DMEntryView *transactorTitleView;
@property (nonatomic, strong) DMEntrySelectView *transactorView;

@property (nonatomic, strong) DMEntryView *coOrganizerTitleView;
@property (nonatomic, strong) DMEntrySelectView *coOrganizerView;

@property (nonatomic, strong) DMEntryView *contentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *contentTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, assign) NSTimeInterval deadlineInterval;
@property (nonatomic, strong) NSMutableDictionary *selectedTransactorDictionary;
@property (nonatomic, strong) NSMutableDictionary *selectedCoOrganizerDictionary;

@end

@implementation DMSuperviseFillinController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinSupervise", @"填写督办任务单");
    
    [self.subviewList addObject:self.deadlineTitleView];
    [self.subviewList addObject:self.deadlineView];
    [self.subviewList addObject:self.transactorTitleView];
    [self.subviewList addObject:self.transactorView];
    [self.subviewList addObject:self.coOrganizerTitleView];
    [self.subviewList addObject:self.coOrganizerView];
    
    [self.subviewList addObject:self.contentTitleView];
    [self.subviewList addObject:self.contentTextView];
    [self.subviewList addObject:self.commitView];
    [self setChildViews:self.subviewList];
    
    self.deadlineInterval = [[NSDate date] timeIntervalSince1970];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMEntryView *)deadlineTitleView {
    if (!_deadlineTitleView) {
        _deadlineTitleView = [[DMEntryView alloc] init];
        [_deadlineTitleView setTitle:NSLocalizedString(@"Deadline", @"截止日期")];
        _deadlineTitleView.lcHeight = 44;
    }
    return _deadlineTitleView;
}

- (DMEntrySelectView *)deadlineView {
    if (!_deadlineView) {
        _deadlineView = [[DMEntrySelectView alloc] init];
        _deadlineView.backgroundColor = [UIColor whiteColor];
        [_deadlineView setPlaceholder:NSLocalizedString(@"DeadlinePlaceholder", @"必选，请选择截止时间")];
        _deadlineView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _deadlineView.clickEntryBlock = ^(NSString *value) {
            // 选择时间
            NSLog(@"选择时间");
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.deadlineInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDate;
            picker.datePicker.minimumDate = [NSDate date];
            //            picker.datePicker.
            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
                weakSelf.deadlineInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日";
                weakSelf.deadlineView.value = [formatter stringFromDate:date];
            };
            [picker show];
        };
    }
    return _deadlineView;
}

- (DMEntryView *)transactorTitleView {
    if (!_transactorTitleView) {
        _transactorTitleView = [[DMEntryView alloc] init];
        [_transactorTitleView setTitle:NSLocalizedString(@"transactor", @"任务办理人")];
        _transactorTitleView.lcHeight = 44;
    }
    return _transactorTitleView;
}

- (DMEntrySelectView *)transactorView {
    if (!_transactorView) {
        _transactorView = [[DMEntrySelectView alloc] init];
        _transactorView.backgroundColor = [UIColor whiteColor];
        [_transactorView setPlaceholder:NSLocalizedString(@"transactor_placeholder", @"请选择任务办理人(必选)")];
        _transactorView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _transactorView.clickEntryBlock = ^(NSString *value) {
            [weakSelf selectTransactor];
        };
    }
    return _transactorView;
}

- (DMEntryView *)coOrganizerTitleView {
    if (!_coOrganizerTitleView) {
        _coOrganizerTitleView = [[DMEntryView alloc] init];
        [_coOrganizerTitleView setTitle:NSLocalizedString(@"co_organizer", @"协办人员")];
        _coOrganizerTitleView.lcHeight = 44;
    }
    return _coOrganizerTitleView;
}

- (DMEntrySelectView *)coOrganizerView {
    if (!_coOrganizerView) {
        _coOrganizerView = [[DMEntrySelectView alloc] init];
        _coOrganizerView.backgroundColor = [UIColor whiteColor];
        [_coOrganizerView setPlaceholder:NSLocalizedString(@"co_organizer_placeholder", @"请选择协办人员(可选,多选)")];
        _coOrganizerView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _coOrganizerView.clickEntryBlock = ^(NSString *value) {
            [weakSelf selectCoOrganizer];
        };
    }
    return _coOrganizerView;
}

- (DMEntryView *)contentTitleView {
    if (!_contentTitleView) {
        _contentTitleView = [[DMEntryView alloc] init];
        [_contentTitleView setTitle:NSLocalizedString(@"TaskContent", @"任务内容")];
        _contentTitleView.lcHeight = 44;
    }
    return _contentTitleView;
}

- (DMMultiLineTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[DMMultiLineTextView alloc] init];
        _contentTextView.lcHeight = 200;
        _contentTextView.backgroundColor = [UIColor whiteColor];
        [_contentTextView setPlaceholder:NSLocalizedString(@"TaskContentPlaceholder", @"必填，请输入任务内容")];
    }
    return _contentTextView;
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

- (void)setSelectedTransactorDictionary:(NSMutableDictionary *)selectedTransactorDictionary {
    _selectedTransactorDictionary = selectedTransactorDictionary;
    NSString *transactorString = @"";
    for (DMUserBookModel *mdl in [selectedTransactorDictionary allValues]) {
        if ([transactorString isEqualToString:@""]) {
            transactorString = mdl.name;
        } else {
            transactorString = [NSString stringWithFormat:@"%@,%@", transactorString, mdl.name];
        }
    }
    self.transactorView.value = transactorString;
}

- (void)setSelectedCoOrganizerDictionary:(NSMutableDictionary *)selectedCoOrganizerDictionary {
    _selectedCoOrganizerDictionary = selectedCoOrganizerDictionary;
    NSString *coOrganizerString = @"";
    for (DMUserBookModel *mdl in [selectedCoOrganizerDictionary allValues]) {
        if ([coOrganizerString isEqualToString:@""]) {
            coOrganizerString = mdl.name;
        } else {
            coOrganizerString = [NSString stringWithFormat:@"%@,%@", coOrganizerString, mdl.name];
        }
    }
    self.coOrganizerView.value = coOrganizerString;
}

#pragma mark - 事件
- (void)selectTransactor {
    DMSelectUserController *controller = [[DMSelectUserController alloc] init];
    controller.isRadio = YES;
    __weak typeof(self) weakSelf = self;
    controller.onSelectUserBlock = ^(NSMutableDictionary *userDict) {
        weakSelf.selectedTransactorDictionary = userDict;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectCoOrganizer {
    DMSelectUserController *controller = [[DMSelectUserController alloc] init];
    __weak typeof(self) weakSelf = self;
    controller.onSelectUserBlock = ^(NSMutableDictionary *userDict) {
        weakSelf.selectedCoOrganizerDictionary = userDict;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commitData {
    if ([self.deadlineView.value isEqualToString:@""]) {
        showToast(@"请选择截止时间");
        return;
    }
    if ([self.transactorView.value isEqualToString:@""]) {
        showToast(@"请选择办理人员");
        return;
    }
    if ([[self.contentTextView getMultiLineText] isEqualToString:@""]) {
        showToast(@"请输入任务内容");
        return;
    }
    
    NSDate *deadlineDt = [NSDate dateWithString:self.deadlineView.value format:@"yyyy年MM月dd日"];
    NSTimeInterval deadlineInterval = [deadlineDt timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *dt = [NSDate dateWithTimeIntervalSince1970:deadlineInterval];
    
    DMSuperviseSubmitRequester *requester = [[DMSuperviseSubmitRequester alloc] init];
    requester.endTime = [formatter stringFromDate:dt];
    
    for (DMUserBookModel *user in [self.selectedTransactorDictionary allValues]) {
        requester.transactorId = user.userId;
        requester.transactorName = user.name;
    }
    
    if (self.selectedCoOrganizerDictionary) {
        if (self.selectedCoOrganizerDictionary.count > 0) {
            NSString *assistsId = @"";
            for (DMUserBookModel *user in [self.selectedCoOrganizerDictionary allValues]) {
                if ([assistsId isEqualToString:@""]) {
                    assistsId = [NSString stringWithFormat:@"%@@%@", user.userId, user.name];
                } else {
                    assistsId = [NSString stringWithFormat:@"%@,%@@%@", assistsId, user.userId, user.name];
                }
            }
            requester.assistsId = assistsId;
        }
    }
    requester.reason = [self.contentTextView getMultiLineText];
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
