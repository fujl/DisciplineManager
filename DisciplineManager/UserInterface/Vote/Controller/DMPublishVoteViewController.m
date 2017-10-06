//
//  DMPublishVoteViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/9/26.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMPublishVoteViewController.h"
#import "DMVoteItemsView.h"
@interface DMPublishVoteViewController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMMultiLineTextView *themeTextView;
@property (nonatomic, strong) DMVoteItemsView *itemsView;


@end

@implementation DMPublishVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Publish", @"发布"), NSLocalizedString(@"vote",@"投票")];
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"发布")];
    
    [self.subviewList addObject:self.themeTextView];
    [self.subviewList addObject:self.itemsView];
    [self setChildViews:self.subviewList];
}

- (void)clickPublish {
    
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

@end
