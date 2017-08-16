//
//  DMTodoCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTodoCell.h"

@interface DMTodoCell ()
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UILabel *createDateView;
@property (nonatomic, strong) UIView *line;
@end

@implementation DMTodoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.nameView];
    [self.contentView addSubview:self.createDateView];
    [self.contentView addSubview:self.line];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.createDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
}

- (UILabel *)nameView {
    if (!_nameView) {
        _nameView = [[UILabel alloc] init];
        _nameView.textColor = [UIColor colorWithRGB:0x000000];
        _nameView.font = [UIFont systemFontOfSize:14];
        _nameView.textAlignment = NSTextAlignmentLeft;
    }
    return _nameView;
}

- (UILabel *)createDateView {
    if (!_createDateView) {
        _createDateView = [[UILabel alloc] init];
        _createDateView.textColor = [UIColor colorWithRGB:0xb2b2b2];
        _createDateView.font = [UIFont systemFontOfSize:11];
        _createDateView.textAlignment = NSTextAlignmentLeft;
    }
    return _createDateView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _line;
}

- (void)setActivitiTaskModel:(DMActivitiTaskModel *)activitiTaskModel {
    _activitiTaskModel = activitiTaskModel;
    self.nameView.text = activitiTaskModel.name;
    self.createDateView.text = activitiTaskModel.createDate;
}
@end
