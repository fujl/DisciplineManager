//
//  DMSelectUserController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSelectUserController.h"
#import "DMOrgView.h"
#import "DMReceiverView.h"

@interface DMSelectUserController ()

@property (nonatomic, strong) DMOrgView *orgView;
@property (nonatomic, strong) DMReceiverView *receiverView;

@end

@implementation DMSelectUserController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isRadio = NO; // 默认多选
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Select_User", @"选择用户");
    [self.view addSubview:self.orgView];
    [self.view addSubview:self.receiverView];
    
    [self addNavRightItem:@selector(clickSure) andTitle:NSLocalizedString(@"sure", @"")];
    
    [self.orgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        CGFloat f = (pow(5, 0.5) - 1) / 2.0f;
        make.width.equalTo(@(SCREEN_WIDTH*(1-f)));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.receiverView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat f = (pow(5, 0.5) - 1) / 2.0f;
        make.top.equalTo(self.view);
        make.left.equalTo(self.orgView.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH*f));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

#pragma mark - getters and setters
- (DMOrgView *)orgView {
    if (!_orgView) {
        _orgView = [[DMOrgView alloc] init];
        _orgView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _orgView.onSelectOrgBlock = ^(DMOrgModel *orgInfo) {
            weakSelf.receiverView.orgInfo = orgInfo;
        };
    }
    return _orgView;
}

- (DMReceiverView *)receiverView {
    if (!_receiverView) {
        _receiverView = [[DMReceiverView alloc] init];
        _receiverView.backgroundColor = [UIColor whiteColor];
    }
    return _receiverView;
}

- (void)setIsRadio:(BOOL)isRadio {
    _isRadio = isRadio;
    self.receiverView.isRadio = isRadio;
}

- (void)clickSure {
    if (self.onSelectUserBlock) {
        self.onSelectUserBlock(self.receiverView.selectedUserDictionary);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
