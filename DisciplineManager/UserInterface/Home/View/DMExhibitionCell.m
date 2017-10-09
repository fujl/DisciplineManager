//
//  DMExhibitionCell.m
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhibitionCell.h"
#import "DMImageCollectionView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "DMImageCollectionCell.h"
#import "DMExhPraiseRequester.h"

@interface DMExhibitionCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *userAvatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) DMImageCollectionView *imageContainView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *praiseBtn;

@end

@implementation DMExhibitionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.userAvatar];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.contentLabel];
        [self.bgView addSubview:self.imageContainView];
        [self.bgView addSubview:self.timeLabel];
        [self.bgView addSubview:self.praiseBtn];
//        self.contentView.bounds = [UIScreen mainScreen].bounds;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
//        [self.bgView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(5);
            make.top.equalTo(self.bgView).offset(5);
            make.width.height.equalTo(@(kUserAvatarSize));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userAvatar.mas_right).offset(5);
            make.top.equalTo(self.userAvatar);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userAvatar.mas_right).offset(5);
            make.right.equalTo(self.bgView.mas_right).offset(-5);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
        [self.imageContainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.left.equalTo(self.userAvatar.mas_right).offset(5);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userAvatar.mas_right).offset(5);
            make.top.equalTo(self.imageContainView.mas_bottom).offset(5);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(5);
        }];
        UIImage *praise = [UIImage imageNamed:@"ic_action_thumb_up"];
        [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timeLabel);
            make.width.equalTo(@(praise.size.width));
            make.height.equalTo(@(praise.size.height));
            make.right.equalTo(self.bgView.mas_right).offset(-5);
        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIImageView *)userAvatar {
    if (!_userAvatar) {
        _userAvatar = [[UIImageView alloc] init];
        _userAvatar.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userAvatar;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithRGB:0x010101];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor blackColor];
    }
    return _contentLabel;
}

- (DMImageCollectionView *)imageContainView {
    if (!_imageContainView) {
        _imageContainView = [[DMImageCollectionView alloc] init];
        _imageContainView.backgroundColor = [UIColor clearColor];
    }
    return _imageContainView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _timeLabel;
}

- (UIButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = [[UIButton alloc] init];
        [_praiseBtn setImage:[UIImage imageNamed:@"ic_action_thumb_up"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"ic_action_thumb_up_pressed"] forState:UIControlStateSelected];
        [_praiseBtn addTarget:self action:@selector(clickPraiseEvent) forControlEvents:UIControlEventTouchUpInside];

    }
    return _praiseBtn;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.timeLabel.frame)+5);
}

- (void)setInfo:(DMExhListModel *)info {
    _info = info;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, info.face]];
    [self.userAvatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.nameLabel.text = info.userName;
    self.contentLabel.text = info.content;
    self.timeLabel.text = info.timeTxt;
    self.praiseBtn.selected = info.userIsPraise;
    if (info.imagePaths.count > 0) {
        CGFloat w = ITEM_INTERVAL*4+3*ITEM_WIDTH;
        CGFloat h = ITEM_INTERVAL*(info.imagePaths.count/3+2)+(info.imagePaths.count/3+1)*ITEM_HEIGHT;
        self.imageContainView.hidden = NO;
        [self.imageContainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w));
            make.height.equalTo(@(h));
        }];
        self.imageContainView.imageStringList = [NSMutableArray arrayWithArray:info.imagePaths];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userAvatar.mas_right).offset(5);
            make.top.equalTo(self.imageContainView.mas_bottom).offset(5);
            make.height.equalTo(@(32));
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-5);
        }];
    } else {
        self.imageContainView.hidden = YES;
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userAvatar.mas_right).offset(5);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.height.equalTo(@(32));
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-5);
        }];
    }
}

- (void)clickPraiseEvent {
    DMExhPraiseRequester *requester = [[DMExhPraiseRequester alloc] init];
    requester.exhId = self.info.elId;
    requester.isPraise = !self.info.userIsPraise;
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            self.info.userIsPraise = !self.info.userIsPraise;
            self.praiseBtn.selected = self.info.userIsPraise;
        }
    }];
}

@end
