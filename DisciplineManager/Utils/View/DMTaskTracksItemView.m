//
//  DMTaskTracksItemView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTaskTracksItemView.h"

@interface DMTaskTracksItemView ()
@property (nonatomic, strong) UILabel *taskNameView;
@property (nonatomic, strong) UILabel *messageView;
@property (nonatomic, strong) UILabel *startTimeView;

@property (nonatomic, strong) UIView *cycleDotView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation DMTaskTracksItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.cycleDotView];
        [self addSubview:self.lineView];
        
        [self addSubview:self.taskNameView];
        [self addSubview:self.messageView];
        [self addSubview:self.startTimeView];
        
        [self.cycleDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.top.equalTo(self);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.cycleDotView);
            make.top.equalTo(self.cycleDotView.mas_bottom);
            make.width.equalTo(@3);
            make.bottom.equalTo(self.startTimeView.mas_bottom);
        }];
        
        
        [self.taskNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cycleDotView.mas_right).offset(10);
            make.top.equalTo(self);
            make.height.equalTo(@44);
        }];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.taskNameView);
            make.top.equalTo(self.taskNameView.mas_bottom);
            make.height.equalTo(@30);
        }];
        [self.startTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.taskNameView);
            make.top.equalTo(self.messageView.mas_bottom);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (UILabel *)taskNameView {
    if (!_taskNameView) {
        _taskNameView = [[UILabel alloc] init];
        _taskNameView.backgroundColor = [UIColor clearColor];
        _taskNameView.textAlignment = NSTextAlignmentLeft;
        _taskNameView.font = kCommitFont;
        _taskNameView.textColor = [UIColor blackColor];
    }
    return _taskNameView;
}

- (UILabel *)messageView {
    if (!_messageView) {
        _messageView = [[UILabel alloc] init];
        _messageView.backgroundColor = [UIColor clearColor];
        _messageView.textAlignment = NSTextAlignmentLeft;
        _messageView.font = kMainFont;
        _messageView.textColor = [UIColor colorWithRGB:0x7f7f7f];
    }
    return _messageView;
}

- (UILabel *)startTimeView {
    if (!_startTimeView) {
        _startTimeView = [[UILabel alloc] init];
        _startTimeView.backgroundColor = [UIColor clearColor];
        _startTimeView.textAlignment = NSTextAlignmentLeft;
        _startTimeView.font = kMainFont;
        _startTimeView.textColor = [UIColor colorWithRGB:0x7f7f7f];
    }
    return _startTimeView;
}

- (UIView *)cycleDotView {
    if (!_cycleDotView) {
        _cycleDotView = [[UIView alloc] init];
        _cycleDotView.layer.masksToBounds = YES;
        _cycleDotView.layer.cornerRadius = 7.5;
    }
    return _cycleDotView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (void)setTaskTracksModel:(DMTaskTracksModel *)taskTracksModel {
    _taskTracksModel = taskTracksModel;
    switch (taskTracksModel.status) {
        case ACTIVITI_STATE_SAVE:
//            self.stateView.text = NSLocalizedString(@"Save", @"保存");
            self.cycleDotView.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
            self.lineView.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
            break;
        case ACTIVITI_STATE_PENDING:
//            self.stateView.text = NSLocalizedString(@"Pending", @"待审核");
            self.cycleDotView.backgroundColor = [UIColor colorWithRGB:0x337ab7];
            self.lineView.backgroundColor = [UIColor colorWithRGB:0x337ab7];
            break;
        case ACTIVITI_STATE_COMPLETE:
//            self.stateView.text = NSLocalizedString(@"Complete", @"已完成");
            self.cycleDotView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
            self.lineView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
            break;
        case ACTIVITI_STATE_REJECTED:
//            self.stateView.text = NSLocalizedString(@"Rejected", @"驳回");
            self.cycleDotView.backgroundColor = [UIColor colorWithRGB:0xd9534f];
            self.lineView.backgroundColor = [UIColor colorWithRGB:0xd9534f];
            break;
        default:
//            self.stateView.text = NSLocalizedString(@"DataError", @"错误数据");
            self.cycleDotView.backgroundColor = [UIColor colorWithRGB:0x777777];
            self.lineView.backgroundColor = [UIColor colorWithRGB:0x777777];
            break;
    }
    
    self.taskNameView.text = [NSString stringWithFormat:@"[%@] %@", _taskTracksModel.operatorUser.operatorName, _taskTracksModel.name];
    self.messageView.text = _taskTracksModel.message;
    self.startTimeView.text = _taskTracksModel.endTime;
}

@end
