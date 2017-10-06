//
//  MsgInterviewImageContainer.m
//  Health
//
//  Created by linxingxi on 16/10/21.
//  Copyright © 2016年 longmaster. All rights reserved.
//

#import "MsgInterviewImageContainer.h"
#import "UIButton+WebCache.h"

@interface MsgInterviewImageContainer ()

@property(nonatomic, assign) NSInteger maxImageCount; //最大图片项个数
@property(nonatomic, assign) NSInteger columns; //列数
@property(nonatomic, assign) NSInteger imageSize; //图片项宽高
@property(nonatomic, assign) NSInteger imageMargin; //图片项间距

@property(nonatomic, strong) NSMutableArray<NSString *> *imageArray;

@property(nonatomic, strong) UIButton *choosePictureButton;

@end

@implementation MsgInterviewImageContainer

const static int TAG = 100;

- (instancetype)initWithMaxImageCount:(NSInteger)count columns:(NSInteger)columns itemMargin:(NSInteger)margin {

    if (self = [super init]) {
        self.maxImageCount = count;
        self.columns = columns;
        self.imageMargin = margin;
        self.imageSize = ([UIScreen mainScreen].bounds.size.width - (columns + 1) * self.imageMargin) / columns;
        self.imageArray = [NSMutableArray array];

        [self initView];
    }
    return self;

}

- (void)initView {
    [self addSubview:[self choosePictureButton]];
    [self layoutChoosePictureButton];
}

#pragma mark 选项按钮

- (UIButton *)choosePictureButton {
    if (!_choosePictureButton) {
        _choosePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choosePictureButton setBackgroundImage:[UIImage imageNamed:@"suggest_photo"] forState:UIControlStateNormal];
        [_choosePictureButton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosePictureButton;
}

#pragma mark 重新设置选项按钮位置

- (void)layoutChoosePictureButton {
    NSInteger row = (_imageArray.count) / self.columns;
    NSInteger col = (_imageArray.count) % self.columns;
    NSInteger leftOffset = self.imageMargin + col * (self.imageSize + self.imageMargin);
    NSInteger topOffset = self.imageMargin + row * (self.imageSize + self.imageMargin);

    [_choosePictureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.imageSize, self.imageSize));
        make.left.equalTo(self).offset(leftOffset);
        make.top.equalTo(self).offset(topOffset);
    }];
}

- (void)choose:(UIButton *)button {
    if (self.choosePicture) {
        _choosePicture();
    }
}

#pragma mark 删除对应项图片

- (void)delete:(UIButton *)button {
//    NSLog(@"---------------tag = %ld",button.superview.tag);
    [[NSFileManager defaultManager] removeItemAtPath:self.imageArray[button.superview.tag - TAG] error:nil];
    //[[PhotosManager sharedInstance] deleteImage:self.imageArray[button.superview.tag - TAG]];
    [self.imageArray removeObjectAtIndex:button.superview.tag - TAG]; //将对应图片地址从数组中移除
    if (self.imageArray.count == 0 && self.empty) { //没有图片项了
        _empty();
    }
    _haveChange = YES;
    
//    NSLog(@"%@",self.imageArray);

    NSInteger startIndex = button.superview.tag;
    for (UIView *view in self.subviews) { //更新被删除项之后的tag标记
        if (view.tag > startIndex) {
            view.tag -= 1;
        }
    }
    [button.superview removeFromSuperview]; //移除该项

    if (self.imageArray.count < self.maxImageCount) {
        self.choosePictureButton.hidden = NO;
    }

    for (NSInteger tag = startIndex; tag < self.imageArray.count + TAG; tag++) {
        //更新被删除项之后项的约束
        UIButton *itemView = [self viewWithTag:tag];
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            NSInteger i = tag - TAG;
            NSInteger row = i / self.columns;
            NSInteger col = i % self.columns;
            NSInteger leftOffset = self.imageMargin + col * (self.imageSize + self.imageMargin);
            NSInteger topOffset = self.imageMargin + row * (self.imageSize + self.imageMargin);

            make.size.mas_equalTo(CGSizeMake(self.imageSize, self.imageSize));
            make.left.equalTo(self).offset(leftOffset);
            make.top.equalTo(self).offset(topOffset);

        }];
    }

    [self layoutChoosePictureButton];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark 添加图片

- (void)addItem:(NSString *)picturePath {

    if (self.imageArray.count >= self.maxImageCount) {
        return;
    }
    [self.imageArray addObject:picturePath];

    if (self.imageArray.count >= self.maxImageCount) {
        self.choosePictureButton.hidden = YES;
    } else {
        self.choosePictureButton.hidden = NO;
    }

    NSInteger i = _imageArray.count - 1;
    NSInteger row = i / self.columns;
    NSInteger col = i % self.columns;
    NSInteger leftOffset = self.imageMargin + col * (self.imageSize + self.imageMargin);
    NSInteger topOffset = self.imageMargin + row * (self.imageSize + self.imageMargin);

    UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom]; //图片项
    itemView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    itemView.tag = TAG + self.imageArray.count - 1; //添加tag标记
    itemView.userInteractionEnabled = YES;
    NSString *path = self.imageArray[i];
    NSRange range = [path rangeOfString:@"https"];
    
    if (range.location != NSNotFound) {
        [itemView sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal];
    } else {
        [itemView sd_setImageWithURL:[NSURL fileURLWithPath:path] forState:UIControlStateNormal];
    }
    [self addSubview:itemView];

    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom]; //图片右上角的删除按钮
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"suggest_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:deleteButton];

    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.imageSize, self.imageSize));
        make.left.equalTo(self).offset(leftOffset);
        make.top.equalTo(self).offset(topOffset);
    }];

    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(itemView.mas_top).offset(-3);
        make.right.equalTo(itemView.mas_right).offset(3);
    }];

    [self layoutChoosePictureButton];
}

- (void)removeAllPictures{
    [self.imageArray removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self addSubview:self.choosePictureButton];
}

- (NSArray<NSString *> *)pictures {
    return self.imageArray;
}


@end


















