//
//  DMAddVoteItemView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAddVoteItemView.h"

@interface DMAddVoteItemView ()

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation DMAddVoteItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.addButton];
        self.backgroundColor = [UIColor whiteColor];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@(40));
        }];
    }
    return self;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        UIImage *add = [UIImage imageNamed:@"ic_action_plus"];
        [_addButton setImage:add forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(clickAddEvent) forControlEvents:UIControlEventTouchUpInside];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton setImageEdgeInsets:UIEdgeInsetsMake((40 - add.size.height)/2.0f, 0, (40 - add.size.height)/2.0f, SCREEN_WIDTH - 20 - add.size.width)];
        NSString *title = NSLocalizedString(@"add_item", @"添加选项");
        [_addButton setTitle:title forState:UIControlStateNormal];
        NSInteger textLength = [title widthForFont:[UIFont systemFontOfSize:14]];
        [_addButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, SCREEN_WIDTH - 20 - 10 - textLength - 40)];
    }
    return _addButton;
}

- (void)clickAddEvent {
    if (self.clickAddItem) {
        self.clickAddItem();
    }
}

@end
