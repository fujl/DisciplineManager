//
//  DMSignTimeView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSignTimeView.h"
#import "DMRepastTitleView.h"

@interface DMSignTimeView ()

@property (nonatomic, strong) DMRepastTitleView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeDifference;
@property (nonatomic, readwrite) BOOL canSign;

@end

@implementation DMSignTimeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.contentLabel];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self);
            make.height.equalTo(@(44));
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.titleView.mas_bottom);
            make.height.equalTo(@(100));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (DMRepastTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DMRepastTitleView alloc] init];
    }
    return _titleView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:24];
        _contentLabel.textColor = [UIColor colorWithRGB:0xd9534f];
    }
    return _contentLabel;
}

- (void)setRepastTimeModel:(DMRepastTimeModel *)repastTimeModel {
    _repastTimeModel = repastTimeModel;
    [self.titleView setTitle:NSLocalizedString(@"sign_time_title", @"剩余打卡时间")];
    
    NSString *datetime = _repastTimeModel.datetime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *dt = [formatter dateFromString:datetime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour |  NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    [self closeTimer];
    if ([self isObsolete:comp]) {
        self.contentLabel.text = NSLocalizedString(@"dining_punch_obsolete", @"就餐打卡已结束");
        self.canSign = NO;
    } else {
        // 算倒计时
        NSTimeInterval timeInterval = [dt timeIntervalSince1970];
        NSString *standard = [NSString stringWithFormat:@"%@ %@", _repastTimeModel.date, @"18:00:00"];
        NSDate *standardDate = [formatter dateFromString:standard];
        NSTimeInterval standardInterval = [standardDate timeIntervalSince1970];
        self.timeDifference = standardInterval - timeInterval;// 时差
        if (self.timeDifference > 0) {
            [self showTimeDifference];
            [self startTimer];
            self.canSign = YES;
        }
    }
}

- (void)signedVote {
    [self closeTimer];
    [self.titleView setTitle:NSLocalizedString(@"sign_time_title", @"剩余打卡时间")];
    self.contentLabel.text = NSLocalizedString(@"signed_vote", @"您已确认需要就餐");
    self.canSign = NO;
}

- (BOOL)isObsolete:(NSDateComponents *)comp {
    if (comp.hour >= 18) {
        return YES;
    } else {
        return NO;
    }
}

- (void)startTimer {
    [self closeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduledTimerEvent) userInfo:nil repeats:YES];
}

- (void)scheduledTimerEvent {
    if (_timeDifference > 0) {
        self.timeDifference--;
        [self showTimeDifference];
    } else {
        self.canSign = NO;
        [self closeTimer];
        self.contentLabel.text = NSLocalizedString(@"dining_punch_obsolete", @"就餐打卡已结束");
        if (self.signObsoleteEvent) {
            self.signObsoleteEvent();
        }
    }
}

- (void)showTimeDifference {
    NSInteger hour = self.timeDifference/(60*60);
    NSInteger minute = (self.timeDifference - (hour*60*60))/60;
    NSInteger second = self.timeDifference - (hour*60*60) - minute*60;
    self.contentLabel.text = [NSString stringWithFormat:@"%zd小时%zd分钟%zd秒", hour, minute, second];
}

- (void)closeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
