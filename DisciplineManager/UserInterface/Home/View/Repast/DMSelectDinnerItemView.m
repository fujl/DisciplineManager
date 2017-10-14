//
//  DMSelectDinnerItemView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSelectDinnerItemView.h"

@interface DMSelectDinnerItemView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedView;

@end

@implementation DMSelectDinnerItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xfafafa]] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xfafafa]] forState:UIControlStateHighlighted];
        [self addSubview:self.nameLabel];
        [self addSubview:self.selectedView];
        [self addTarget:self action:@selector(clickSelectEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
            make.right.equalTo(self.selectedView.mas_left).offset(-5);
        }];
        UIImage *check = [UIImage imageNamed:@"ic_action_check"];
        [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-5);
            make.width.equalTo(@(check.size.width));
            make.height.equalTo(@(check.size.height));
        }];
        self.selectedView.hidden = !self.selected;
    }
    return self;
}

#pragma mark - getters and setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.userInteractionEnabled = NO;
    }
    return _nameLabel;
}

- (UIImageView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIImageView alloc] init];
        _selectedView.image = [UIImage imageNamed:@"ic_action_check"];
        _selectedView.userInteractionEnabled = YES;
    }
    return _selectedView;
}

- (void)setDishModel:(DMDishModel *)dishModel {
    _dishModel = dishModel;
    self.nameLabel.text = dishModel.dishesName;
}

- (void)clickSelectEvent {
    self.selected = !self.selected;
    self.selectedView.hidden = !self.selected;
}

@end
