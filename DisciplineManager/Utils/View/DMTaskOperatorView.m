//
//  DMTaskOperatorView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTaskOperatorView.h"

@interface DMTaskOperatorView ()
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *rejectedButton;
@property (nonatomic, strong) UIButton *transferCommentButton;

@end

@implementation DMTaskOperatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    
        [self addSubview:self.agreeButton];
        [self addSubview:self.rejectedButton];
        [self addSubview:self.transferCommentButton];
    }
    return self;
}

- (void)refreshView:(BOOL)showTransferComment {
    CGFloat sep = 20;
    CGFloat width;
    if (showTransferComment) {
        width = (SCREEN_WIDTH-4*sep)/3.0;
    } else {
        width = (SCREEN_WIDTH-3*sep)/2.0;
    }
    
    [self.agreeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(sep);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@(width));
        make.height.equalTo(@44);
    }];
    [self.rejectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-sep);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@(width));
        make.height.equalTo(@44);
    }];
    if (showTransferComment) {
        self.transferCommentButton.hidden = YES;
        [self.rejectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
            make.width.equalTo(@(width));
            make.height.equalTo(@44);
        }];
    } else {
        self.transferCommentButton.hidden = YES;
    }
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x5cb85c]] forState:UIControlStateNormal];
        _agreeButton.layer.masksToBounds = YES;
        _agreeButton.layer.cornerRadius = 3;
        [_agreeButton addTarget:self action:@selector(clickAgree) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (UIButton *)rejectedButton {
    if (!_rejectedButton) {
        _rejectedButton = [[UIButton alloc] init];
        [_rejectedButton setTitle:@"驳回" forState:UIControlStateNormal];
        [_rejectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rejectedButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xd9534f]] forState:UIControlStateNormal];
        _rejectedButton.layer.masksToBounds = YES;
        _rejectedButton.layer.cornerRadius = 3;
        [_rejectedButton addTarget:self action:@selector(clickRejected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectedButton;
}

- (UIButton *)transferCommentButton {
    if (!_transferCommentButton) {
        _transferCommentButton = [[UIButton alloc] init];
        [_transferCommentButton setTitle:@"转批" forState:UIControlStateNormal];
        [_transferCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_transferCommentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x337ab7]] forState:UIControlStateNormal];
        _transferCommentButton.layer.masksToBounds = YES;
        _transferCommentButton.layer.cornerRadius = 3;
        [_transferCommentButton addTarget:self action:@selector(clickTransferComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferCommentButton;
}

- (void)clickAgree {
    if (self.clickTaskOperatorBlock) {
        self.clickTaskOperatorBlock(TaskOperator_Agree);
    }
}

- (void)clickRejected {
    if (self.clickTaskOperatorBlock) {
        self.clickTaskOperatorBlock(TaskOperator_Rejected);
    }
}

- (void)clickTransferComment {
    if (self.clickTaskOperatorBlock) {
        self.clickTaskOperatorBlock(TaskOperator_TransferComment);
    }
}
@end
