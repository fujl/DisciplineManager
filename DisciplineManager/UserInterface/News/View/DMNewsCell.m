//
//  HMOnlinePatientCell.m
//  HealthMate
//
//  Created by fujl-mac on 2017/7/22.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNewsCell.h"

@interface DMNewsCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *contentsView;
@property (nonatomic, strong) UILabel *createDateView;
@property (nonatomic, strong) UILabel *readView;
@end

@implementation DMNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleView];
        [self.contentView addSubview:self.contentsView];
        [self.contentView addSubview:self.createDateView];
//        [self.contentView addSubview:self.readView];
    
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.width.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView).offset(5);
        }];
        
        [self.contentsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.top.equalTo(self.titleView.mas_bottom).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.createDateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.bottom.equalTo(self.iconView.mas_bottom).offset(5);
        }];
        
//        [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(self.iconView.mas_bottom).offset(5);
//        }];
    }
    return self;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xefefef];
    }
    return _line;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.userInteractionEnabled = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.text = @"专家在线问诊";
        _titleView.font = [UIFont systemFontOfSize:15.0f];
        _titleView.textColor = [UIColor blackColor];
        _titleView.numberOfLines = 2;
    }
    return _titleView;
}

- (UILabel *)contentsView {
    if (!_contentsView) {
        _contentsView = [[UILabel alloc] init];
        _contentsView.text = @"专家在线问诊";
        _contentsView.font = [UIFont systemFontOfSize:13.0f];
        _contentsView.textColor = [UIColor colorWithRGB:0x7f7f7f];
        _contentsView.numberOfLines = 2;
    }
    return _contentsView;
}

- (UILabel *)createDateView {
    if (!_createDateView) {
        _createDateView = [[UILabel alloc] init];
        _createDateView.text = @"专家在线问诊";
        _createDateView.font = [UIFont systemFontOfSize:12.0f];
        _createDateView.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _createDateView;
}

- (UILabel *)readView {
    if (!_readView) {
        _readView = [[UILabel alloc] init];
        _readView.text = @"专家在线问诊";
        _readView.font = [UIFont systemFontOfSize:12.0f];
        _readView.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _readView;
}

// 时间的格式处理：输入要处理时间戳，返回一个10位的规范的时间戳
- (double)correctTimestamp:(double)timestamp{
    if(timestamp < (double)1000000000){
        timestamp = [[NSDate date] timeIntervalSince1970];
    }else if(timestamp > (double)9999999999)
        timestamp = timestamp / 1000;
    else if(timestamp > (double)9999999999999)
        timestamp = timestamp / 1000 / 1000;
    return timestamp;
}

/**
 *  输入要处理时间戳，返回 "YYYY-MM-dd HH:mm"格式字符串
 *  1.一天内:"HH:mm"
 *  2.昨天: "昨天 HH:mm"
 *  3.一年内:"MM-dd"
 *  4.一年前: "YYYY-MM-dd"
 */
- (NSString*)formatTimestamp:(double)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    // 1.算出现在到凌时的时间间隔 delta
    // 2.算出消息发出时间到现在的时间间隔 deltaToMorning
    // 3. delta > deltaToMorning  今天  ||  delta < deltaToMorning 今天以前
    NSDate *now = [NSDate date];
    NSInteger nowYear = now.year;
    
    formatter.dateFormat = @"YYYY/MM/dd";
    NSString *dateString = [formatter stringFromDate:now];
    // 凌晨时间
    NSDate *dateMorning = [formatter dateFromString:dateString];
    // 现在到凌晨时间间隔
    NSTimeInterval deltaToMorning = [now timeIntervalSinceDate:dateMorning];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self correctTimestamp:timestamp]];
    NSInteger timeYear = date.year;
    
    // 现在到发送时间间隔
    NSTimeInterval deltaToNow = [now timeIntervalSinceDate:date];
    if (timeYear != nowYear) {
        formatter.dateFormat = @"YYYY/MM/dd";
        return [formatter stringFromDate:date];
    } else {
        if (deltaToNow < deltaToMorning) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
            return [formatter stringFromDate:date];
        }else{
            // 发送时间到今天凌晨 时间间隔
            NSTimeInterval delta = deltaToNow - deltaToMorning;
            if (delta <= 60 * 60 * 24*1) {
                formatter.dateFormat = @"昨天 HH:mm";
                return [formatter stringFromDate:date];
            }else if (delta >= 60 * 60 * 24*365) { // 一年外
                formatter.dateFormat = @"YYYY/MM/dd HH:mm";
                return [formatter stringFromDate:date];
            }else { // 一年内
                formatter.dateFormat = @"MM/dd HH:mm";
                return [formatter stringFromDate:date];
            }
        }
    }
}

- (void)setNewsInfoModel:(DMCmsContentModel *)newsInfoModel {
    _newsInfoModel = newsInfoModel;
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:newsInfoModel.imgPath]];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:newsInfoModel.imgPath] placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.titleView.text = _newsInfoModel.title;
    self.contentsView.text = _newsInfoModel.shortTitle;
    self.createDateView.text = _newsInfoModel.createTime;
//    self.readView.text = [NSString stringWithFormat:@"%zd", _newsInfoModel.read];
}

@end
