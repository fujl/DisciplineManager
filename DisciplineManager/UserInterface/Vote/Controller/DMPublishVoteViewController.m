//
//  DMPublishVoteViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/9/26.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMPublishVoteViewController.h"
#import "DMVoteItemsView.h"
#import "DMReleaseVoteRequester.h"

@interface DMPublishVoteViewController () <UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMMultiLineTextView *themeTextView;
@property (nonatomic, strong) DMVoteItemsView *itemsView;
@property (nonatomic, strong) DMSelectItemView *typeSelectView;
@property (nonatomic, strong) DMSelectItemView *endDateView;

@property (nonatomic, assign) DMVoteType voteType;
@property (nonatomic, assign) NSTimeInterval endTime;

@property (nonatomic, strong) NSDate *currentDt;

@end

@implementation DMPublishVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Publish", @"发布"), NSLocalizedString(@"vote",@"投票")];
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"发布")];
    
    NSDate *dt = [NSDate date];
    self.endTime = [dt timeIntervalSince1970] + 60*10;
    self.currentDt = [NSDate dateWithTimeIntervalSince1970:self.endTime];
    
    [self.subviewList addObject:self.themeTextView];
    [self.subviewList addObject:self.itemsView];
    [self.subviewList addObject:self.typeSelectView];
    [self.subviewList addObject:self.endDateView];
    [self setChildViews:self.subviewList];
    
    
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMMultiLineTextView *)themeTextView {
    if (!_themeTextView) {
        _themeTextView = [[DMMultiLineTextView alloc] init];
        _themeTextView.lcHeight = 44;
        [_themeTextView setMaxMultiLineTextLength:20];
        _themeTextView.backgroundColor = [UIColor whiteColor];
        [_themeTextView setPlaceholder:NSLocalizedString(@"vote_theme_placeholder", @"请输入投票主题，8-20字")];
    }
    return _themeTextView;
}

- (DMVoteItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[DMVoteItemsView alloc] init];
        _itemsView.lcTopMargin = 10;
    }
    return _itemsView;
}

- (DMSelectItemView *)typeSelectView {
    if (!_typeSelectView) {
        _typeSelectView = [[DMSelectItemView alloc] init];
        _typeSelectView.title = NSLocalizedString(@"vote_type", @"投票类型");
        _typeSelectView.value = NSLocalizedString(@"radio", @"单选");
        self.voteType = DMVoteTypeRadio;
        _typeSelectView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _typeSelectView.clickEntryBlock = ^(NSString *value) {
            [weakSelf clickTypeSelectView];
        };
    }
    return _typeSelectView;
}

- (DMSelectItemView *)endDateView {
    if (!_endDateView) {
        _endDateView = [[DMSelectItemView alloc] init];
        _endDateView.title = NSLocalizedString(@"EndTime", @"结束时间");
        _endDateView.value = [self getEndDate:self.endTime];
        _endDateView.lcHeight = 44;
        _endDateView.lcTopMargin = 0.5;
        __weak typeof(self) weakSelf = self;
        _endDateView.clickEntryBlock = ^(NSString *value) {
            [weakSelf clickEndDateView];
        };
    }
    return _endDateView;
}

- (NSString *)getEndDate:(NSTimeInterval)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *dt = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [formatter stringFromDate:dt];
}

#pragma mark - event
- (void)clickTypeSelectView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"radio", @"单选"), NSLocalizedString(@"checkbox", @"多选"), nil];
    [actionSheet showInView:self.view];
}

- (void)clickEndDateView {
    DMDatePickerView *picker = [[DMDatePickerView alloc] init];
    picker.datePicker.date = [NSDate dateWithTimeIntervalSince1970:self.endTime];
    picker.datePicker.minimumDate = self.currentDt;
    picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    __weak typeof(self) weakSelf = self;
    picker.onCompleteClick = ^(DMDatePickerView *datePicker, NSDate *date) {
        weakSelf.endTime = [date timeIntervalSince1970];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        weakSelf.endDateView.value = [formatter stringFromDate:date];
    };
    [picker show];
}

- (void)clickPublish {
    NSString *theme = [self.themeTextView getMultiLineText];
    if (theme.length < 8) {
        showToast(NSLocalizedString(@"vote_theme_placeholder", @"请输入投票主题，8-20字"));
        return;
    }
    NSMutableArray *options = [[NSMutableArray alloc] init];
    NSInteger number = 1;
    for (DMVoteItemView *itemView in self.itemsView.subItemViews) {
        NSString *itemText = [itemView itemText];
        if (itemText.length <= 0) {
            showToast(NSLocalizedString(@"vote_item_check", @"选项不允许为空，且不得超过40个字"));
            return;
        }
        NSDictionary *option = @{
                                 @"text":itemText,
                                 @"number":@(number++)
                                 };
        [options addObject:option];
    }

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    if (self.endTime < timeInterval) {
        showToast(NSLocalizedString(@"vote_end_time_check", @"投票结束时间不得小于当前时间"));
        return;
    }
    
    DMReleaseVoteRequester *requester = [[DMReleaseVoteRequester alloc] init];
    requester.title = theme;
    requester.options = options;
    requester.type = self.voteType;
    requester.endTime = [self getEndDate:self.endTime];
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.voteType = DMVoteTypeRadio;
            self.typeSelectView.value = NSLocalizedString(@"radio", @"单选");
            break;
        case 1:
            self.voteType = DMVoteTypeCheckbox;
            self.typeSelectView.value = NSLocalizedString(@"checkbox", @"多选");
            break;
        default:
            break;
    }
}

@end
