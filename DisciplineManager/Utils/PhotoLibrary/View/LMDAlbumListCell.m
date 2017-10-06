//
//  LMDAlbumListCell.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDAlbumListCell.h"
#import "LMDPhotosManager.h"

@interface LMDAlbumListCell ()
@property (nonatomic, strong) UIImageView *postImage;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UIImageView *arrow;
@end

@implementation LMDAlbumListCell

-(void)setModel:(LMDAlbumModel *)model{
    _model = model;
    [[LMDPhotosManager sharedInstance] getPostImageWithAlbumModel:_model completion:^(UIImage *postImage) {
        [self setUpViews];
        _postImage.image = postImage;
        [self layoutViews];
    }];
    
}

- (void)setUpViews{
    [self addSubview:self.postImage];
    [self addSubview:self.albumNameLabel];
    [self addSubview:self.arrow];
}

- (void)layoutViews{
    [_postImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.width.height.equalTo(@57);
        make.centerY.equalTo(self);
    }];
    
    [_albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_postImage.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_postImage.mas_right).offset(10);
        make.height.equalTo(@0.5);
        make.bottom.right.equalTo(self);
    }];
}

#pragma mark lazy load
- (UIImageView *)postImage{
    if (!_postImage) {
        _postImage = [[UIImageView alloc]init];
        _postImage.contentMode = UIViewContentModeScaleAspectFill;
        _postImage.clipsToBounds = YES;
    }
    return _postImage;
}

- (UILabel *)albumNameLabel{
    if (!_albumNameLabel) {
        _albumNameLabel = [[UILabel alloc]init];
        _albumNameLabel.font = [UIFont systemFontOfSize:15];
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:_model.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%zd)",_model.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x7f7f7f]}];
        [nameString appendAttributedString:countString];
        _albumNameLabel.attributedText = nameString;
    }
    return _albumNameLabel;
}

- (UIImageView *)arrow{
    if (!_arrow) {
        _arrow = [[UIImageView alloc]init];
        _arrow.image = [UIImage imageNamed:@"album_cell_arrow"];
        _arrow.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrow;
}

@end
