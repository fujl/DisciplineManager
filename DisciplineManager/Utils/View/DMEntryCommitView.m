//
//  DMEntryCommitView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/17.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMEntryCommitView.h"

@interface DMEntryCommitView ()
@property (nonatomic, strong) UIButton *commitBtn;
@end

@implementation DMEntryCommitView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.commitBtn];
        
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        UIImage *image = [UIImage imageWithColor:kCommitBtnColor];
        [_commitBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = kCommitFont;
        [_commitBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.layer.cornerRadius = 3;
        [_commitBtn setTitle:NSLocalizedString(@"Commit", @"提交") forState:UIControlStateNormal];
    }
    return _commitBtn;
}

#pragma mark - event method
- (void)clickCommitBtn {
    if (self.clickCommitBlock) {
        self.clickCommitBlock();
    }
}

- (void)setCommitTitle:(NSString *)title {
    [self.commitBtn setTitle:title forState:UIControlStateNormal];
}

@end
