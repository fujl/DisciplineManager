//
//  LMDPhotoPickCollectionViewCell.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDPhotoPickCollectionViewCell.h"
#import "LMDPhotosManager.h"

@interface LMDPhotoPickCollectionViewCell ()
@property (nonatomic, strong)UIImageView *pic;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UIImageView *icon;
@end

@implementation LMDPhotoPickCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
        [self layoutViews];
    }
    return self;
}

- (void)setModel:(LMDAssetModel *)model {
    _model = model;
    _pic.image = nil;
    __weak typeof(model)weakModel = model;
    [[LMDPhotosManager sharedInstance] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if ([weakModel isEqual:self.model]) {
            _pic.image = photo;
        }
    }];
    if (model.isselected) {
        _icon.image = [UIImage imageNamed:@"album_imagepick_choosed"] ;
    } else {
        _icon.image = [UIImage imageNamed:@"album_imagepick_unchoose"];
    }
}
- (void)recallIcon{
    _icon.image = [UIImage imageNamed:@"album_imagepick_unchoose"];
    _model.isselected = NO;
}
- (void)setUpViews{
    [self addSubview:self.pic];
    [self addSubview:self.selectBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImagePreview)];
    [self.pic addGestureRecognizer:tap];
    
}
- (void)showImagePreview{
    if (self.imageClick) {
        self.imageClick(_item);
    }
}
- (void)layoutViews{
    [_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.height.equalTo(@40);
    }];
}

- (UIImageView *)pic{
    if (!_pic) {
        _pic = [[UIImageView alloc]init];
        _pic.contentMode = UIViewContentModeScaleAspectFill;
        _pic.userInteractionEnabled = YES;
        _pic.clipsToBounds = YES;
    }
    return _pic;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"album_imagepick_unchoose"]];
        [_selectBtn addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(_selectBtn);
        }];
        [_selectBtn addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectBtn;
}

- (void)selectImage{
    _model.isselected  = !_model.isselected;
    if (_model.isselected) {
        _icon.image = [UIImage imageNamed:@"album_imagepick_choosed"] ;
    } else {
        _icon.image = [UIImage imageNamed:@"album_imagepick_unchoose"];
    }
    if (_selectBlock) {
        _selectBlock(_item);
    }
}

@end
