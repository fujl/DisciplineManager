//
//  DMNoticePublishController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticePublishController.h"
#import "DMSelectUserController.h"
#import "DMUserBookModel.h"

@interface DMNoticePublishController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) DMEntryView *detailsTitleView;
@property (nonatomic, strong) DMEntrySelectView *detailsView;

@property (nonatomic, strong) DMEntryView *titleTitleView;
@property (nonatomic, strong) DMSingleTextView *titleView;
@property (nonatomic, strong) DMEntryView *contentTitleView;
@property (nonatomic, strong) DMMultiLineTextView *contentTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, strong) NSMutableDictionary *selectedUserDictionary;

@end

@implementation DMNoticePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"publish_notice", @"发布通知");
    
    [self addNavRightItem:@selector(clickCommit) andTitle:NSLocalizedString(@"Commit", @"")];
    
    [self.subviewList addObject:self.detailsTitleView];
    [self.subviewList addObject:self.detailsView];
    [self.subviewList addObject:self.titleTitleView];
    [self.subviewList addObject:self.titleView];
    [self.subviewList addObject:self.contentTitleView];
    [self.subviewList addObject:self.contentTextView];
    [self.subviewList addObject:self.commitView];
    [self setChildViews:self.subviewList];
}

- (void)clickCommit {
    
}

- (void)selectDetails {
    DMSelectUserController *controller = [[DMSelectUserController alloc] init];
    __weak typeof(self) weakSelf = self;
    controller.onSelectUserBlock = ^(NSMutableDictionary *userDict) {
        weakSelf.selectedUserDictionary = userDict;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

//- (UILabel *)tipLabel {
//    if (!_tipLabel) {
//        _tipLabel = [[UILabel alloc] init];
//        _tipLabel.font = [UIFont systemFontOfSize:14];
//        _tipLabel.textColor = [UIColor colorWithRGB:0x5f5f5f];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        _tipLabel.text = NSLocalizedString(@"Notice_Header_Tip", @"温馨提示：接收人不选择默认发送全部");
//        _tipLabel.lcHeight = 44;
//    }
//    return _tipLabel;
//}

- (DMEntryView *)detailsTitleView {
    if (!_detailsTitleView) {
        _detailsTitleView = [[DMEntryView alloc] init];
        [_detailsTitleView setTitle:NSLocalizedString(@"receiver", @"接收人")];
        _detailsTitleView.lcHeight = 44;
    }
    return _detailsTitleView;
}

- (DMEntrySelectView *)detailsView {
    if (!_detailsView) {
        _detailsView = [[DMEntrySelectView alloc] init];
        _detailsView.backgroundColor = [UIColor whiteColor];
        [_detailsView setPlaceholder:NSLocalizedString(@"Notice_Header_Tip", @"温馨提示：接收人不选择默认发送全部")];
        _detailsView.lcHeight = 44;
        __weak typeof(self) weakSelf = self;
        _detailsView.clickEntryBlock = ^(NSString *value) {
            [weakSelf selectDetails];
        };
    }
    return _detailsView;
}

- (DMEntryView *)titleTitleView {
    if (!_titleTitleView) {
        _titleTitleView = [[DMEntryView alloc] init];
        [_titleTitleView setTitle:NSLocalizedString(@"NoticeTitle", @"通知标题")];
        _titleTitleView.lcHeight = 44;
    }
    return _titleTitleView;
}

- (DMSingleTextView *)titleView {
    if (!_titleView) {
        _titleView = [[DMSingleTextView alloc] init];
        _titleView.lcHeight = 44;
        _titleView.backgroundColor = [UIColor whiteColor];
        [_titleView setPlaceholder:NSLocalizedString(@"NoticeTitlePlaceholder", @"必填，请输入通知标题")];
    }
    return _titleView;
}

- (DMEntryView *)contentTitleView {
    if (!_contentTitleView) {
        _contentTitleView = [[DMEntryView alloc] init];
        [_contentTitleView setTitle:NSLocalizedString(@"NoticeContent", @"通知内容")];
        _contentTitleView.lcHeight = 44;
    }
    return _contentTitleView;
}

- (DMMultiLineTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[DMMultiLineTextView alloc] init];
        _contentTextView.lcHeight = 200;
        _contentTextView.backgroundColor = [UIColor whiteColor];
        [_contentTextView setPlaceholder:NSLocalizedString(@"NoticeContentPlaceholder", @"必填，请输入通知内容")];
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

- (void)commitData {
}

- (void)setSelectedUserDictionary:(NSMutableDictionary *)selectedUserDictionary {
    _selectedUserDictionary = selectedUserDictionary;
    NSString *receiverString = @"";
    for (DMUserBookModel *mdl in [selectedUserDictionary allValues]) {
        if ([receiverString isEqualToString:@""]) {
            receiverString = mdl.name;
        } else {
            receiverString = [NSString stringWithFormat:@"%@,%@", receiverString, mdl.name];
        }
    }
    self.detailsView.value = receiverString;
}

@end
