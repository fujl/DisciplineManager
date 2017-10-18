//
//  DMSuperviseFillinController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviseFillinController.h"

@interface DMSuperviseFillinController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *deadlineTitleView;
@property (nonatomic, strong) DMEntrySelectView *deadlineView;

@property (nonatomic, assign) NSTimeInterval deadlineInterval;

@end

@implementation DMSuperviseFillinController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinSupervise", @"填写督办任务单");
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
        [_deadlineTitleView setTitle:NSLocalizedString(@"OutTime", @"外出时间")];
        _deadlineTitleView.lcHeight = 44;
    }
    return _deadlineTitleView;
}

- (DMEntrySelectView *)deadlineView {
    if (!_deadlineView) {
        _deadlineView = [[DMEntrySelectView alloc] init];
        _deadlineView.backgroundColor = [UIColor whiteColor];
        [_deadlineView setPlaceholder:NSLocalizedString(@"OutTimePlaceholder", @"必选，请选择外出时间")];
        _deadlineView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _deadlineView.clickEntryBlock = ^(NSString *value) {
            // 选择时间
            NSLog(@"选择时间");
            [AppWindow endEditing:YES];
            DMDatePickerView *picker = [[DMDatePickerView alloc] init];
            picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:weakSelf.deadlineInterval];
            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            picker.datePicker.minimumDate = [NSDate date];
            //            picker.datePicker.
            picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
                weakSelf.deadlineInterval = [date timeIntervalSince1970];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
                weakSelf.deadlineView.value = [formatter stringFromDate:date];
            };
            [picker show];
        };
    }
    return _deadlineView;
}

@end
