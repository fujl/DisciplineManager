//
//  DMMainItemView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMainItemView.h"

#define kMainItemWidth  ((SCREEN_WIDTH-1)/3.0f)

@interface DMMainItemView ()
@property (nonatomic, strong) UILabel *titleView;
@end

@implementation DMMainItemView

- (instancetype)initWithIcon:(NSString *)icon {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImage *itemImage = [UIImage imageNamed:icon];
        self.height = itemImage.size.height+40;
        self.width = kMainItemWidth;
        [self setImage:itemImage forState:UIControlStateNormal];
        // top, left, bottom, right
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, (kMainItemWidth-itemImage.size.width)/2.0f, 30, (kMainItemWidth-itemImage.size.width)/2.0f)];
        
        [self addSubview:self.titleView];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
    }
    return self;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = [UIFont systemFontOfSize:14];
        _titleView.textColor = [UIColor blackColor];
    }
    return _titleView;
}

- (void)setTitleViewText:(NSString *)titleText {
    self.titleView.text = titleText;
}

@end
