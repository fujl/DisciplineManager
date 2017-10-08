//
//  DMImageCollectionCell.m
//  DisciplineManager
//
//  Created by apple on 2017/10/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMImageCollectionCell.h"

@interface DMImageCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *clickBtn;

@end
@implementation DMImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.clickBtn];
        [self.clickBtn addSubview:self.imageView];
        self.clipsToBounds = YES;
        [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.clickBtn);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] init];
        [_clickBtn addTarget:self action:@selector(onImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    NSString *url = [NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, fileName];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_error"]];
}

- (void)onImageClick {
    NSLog(@"%zd", self.index);
    if (self.clickImageAtIndex) {
        self.clickImageAtIndex(self.index, self.fileName);
    }
}

@end
