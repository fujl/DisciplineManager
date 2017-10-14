//
//  DMMarqueeView.m
//  DisciplineManager
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "DMMarqueeView.h"

@interface DMMarqueeView ()

@property (nonatomic, strong) UILabel *marqueeLabel;
@property (nonatomic, assign) CGSize sizeOfText;

@property (nonatomic,strong) NSTimer* timer;// 定义定时器
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat step;
@end

@implementation DMMarqueeView

- (instancetype)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xfd9a70];
        self.clipsToBounds = YES;
        
        self.marqueeLabel.text = title;
        
        //计算textLb大小
        self.sizeOfText = [self.marqueeLabel sizeThatFits:CGSizeZero];
        
        self.originX = SCREEN_WIDTH*1.0f;
        self.step = 2.0f;
        self.marqueeLabel.frame = CGRectMake(self.originX+self.step, (44-self.sizeOfText.height)/2.0f, self.sizeOfText.width, self.sizeOfText.height);
        
        [self addSubview:self.marqueeLabel];
    }
    return self;
}

- (UILabel *)marqueeLabel {
    if (!_marqueeLabel) {
        _marqueeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _marqueeLabel.textColor = TEXTCOLOR;
        _marqueeLabel.font = [UIFont boldSystemFontOfSize:TEXTFONTSIZE];
    }
    return _marqueeLabel;
}

- (void)start{
    [self stop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self selector:@selector(changePosition)
                                                userInfo:nil repeats:YES];
}

- (void)stop{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)changePosition {
    self.originX -= self.step;
    [UIView animateWithDuration:0.1 animations:^{
        if (self.originX < -self.sizeOfText.width) {
            self.marqueeLabel.hidden = YES;
        }
        self.marqueeLabel.frame = CGRectMake(self.originX, (44-self.sizeOfText.height)/2.0f, self.sizeOfText.width, self.sizeOfText.height);
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.originX < -self.sizeOfText.width) {
                self.marqueeLabel.hidden = NO;
                self.originX = SCREEN_WIDTH + self.step;
            }
            self.marqueeLabel.frame = CGRectMake(self.originX, (44-self.sizeOfText.height)/2.0f, self.sizeOfText.width, self.sizeOfText.height);
        }
    }];
}

@end
