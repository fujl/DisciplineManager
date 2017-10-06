//
//  LMDPhotoPreviewCollectionViewCell.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDPhotoPreviewCollectionViewCell.h"

@interface LMDPhotoPreviewCollectionViewCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation LMDPhotoPreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    [self addSubview:self.scroll];
    [self.scroll addSubview:self.container];
    [self.container addSubview:self.imageView];
}

- (void)resizeSubViews{
    CGRect frame = CGRectZero;
    _imageView.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    float height;
    float width;
    if (_image.size.width >= _image.size.height) {
        width = self.frame.size.width;
        height = floor(_image.size.height / _image.size.width * self.frame.size.width);
        frame.origin.y = self.frame.size.height > height ? (self.frame.size.height - height) / 2 : 0;
    } else {
        height = self.frame.size.height;
        width = floor(_image.size.width / _image.size.height * self.frame.size.height);
        frame.origin.x = (self.frame.size.width - width) / 2;
        if (width > self.frame.size.width) {
            width = self.frame.size.width;
            height = floor(_image.size.height / _image.size.width * self.frame.size.width);
            frame.origin.x = 0;
            frame.origin.y = (self.frame.size.height - height) / 2;
        }
        
    }
    _scroll.contentSize = CGSizeMake(width,height > self.frame.size.height ? height:self.frame.size.height);
    
    frame.size.width = width;
    frame.size.height = height;
    _container.frame = frame;
    _container.center = CGPointMake(_container.center.x, _scroll.contentSize.height/2);
    _imageView.frame = CGRectMake(0, 0, width, height);
    [_scroll scrollRectToVisible:self.bounds animated:NO];
}

- (void)recoverSubViews{
    [_scroll setZoomScale:1.0 animated:NO];
    [self resizeSubViews];
}
#pragma mark scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _container;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.frame.size.width > scrollView.contentSize.width ? fabs(scrollView.frame.size.width - scrollView.contentSize.width) / 2 : 0;
    CGFloat offsetY = scrollView.frame.size.height > scrollView.contentSize.height ? fabs(scrollView.frame.size.height - scrollView.contentSize.height) / 2 : 0;
    _container.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)singleTap{
    if (self.singleImageBlock) {
        self.singleImageBlock();
    }
}
- (void)doubleTap{
    if (_scroll.zoomScale == 1) {
        [_scroll setZoomScale:2.0 animated:YES];
    } else {
        [_scroll setZoomScale:1 animated:YES];
    }
}
#pragma mark lazy load
- (void)setModel:(LMDAssetModel *)model{
    _model = model;
    __block typeof(self)weakSelf = self;
    [[LMDPhotosManager sharedInstance] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _image = photo;
        _imageView.image = _image;
        [weakSelf resizeSubViews];
    }];
}

- (UIScrollView *)scroll{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scroll.delegate = self;
        _scroll.maximumZoomScale = 2.0;
        _scroll.minimumZoomScale = 1;
        _scroll.bouncesZoom = YES;
        _scroll.multipleTouchEnabled = YES;
        _scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
    }
    return _scroll;
}
- (UIView *)container{
    if (!_container) {
        _container = [[UIView alloc]init];
        _container.clipsToBounds = YES;
    }
    return _container;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView =  [[UIImageView alloc]init];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
        UITapGestureRecognizer *doubleTap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
        [doubleTap setNumberOfTapsRequired:2];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [_imageView addGestureRecognizer:singleTap];
        [_imageView addGestureRecognizer:doubleTap];
    }
    return _imageView;
}

@end
