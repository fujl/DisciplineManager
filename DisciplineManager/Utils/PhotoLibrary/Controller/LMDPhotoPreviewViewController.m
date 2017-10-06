//
//  LMDPhotoPreviewViewController.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDPhotoPreviewViewController.h"
#import "LMDAlbumPickerViewController.h"
#import "LMDPhotosManager.h"
#import "LMDPhotoPreviewCollectionViewCell.h"

@interface LMDPhotoPreviewViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *dumyStatusBar;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *circle;
@property (nonatomic, strong) UIButton *completeBtn;

@property (nonatomic, strong) NSMutableArray *realSelect;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL hideViews;
@end

@implementation LMDPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _currentShow = 0;
    _hideViews = NO;
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    _realSelect = [NSMutableArray arrayWithArray:nav.selectedModels];
    [self setUpViews];
    [self layoutViews];
    [self refreshBottom];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    nav.selectedModels = _realSelect;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    if (_indexPath) {
        [_collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        _indexPath = nil;
    }
}


- (void)setUpViews{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
}
- (void)layoutViews{
    _dumyStatusBar = [[UIView alloc]init];
    
    _dumyStatusBar.backgroundColor = [UIColor colorWithRGB:0x333333];
    [self.view addSubview:_dumyStatusBar];
    [_dumyStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(_dumyStatusBar.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark funcs
- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)outOfNumber{
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"photo_maxnumber", @"您最多只能选择%ld张照片"),nav.maxImageNumber] delegate:self cancelButtonTitle:NSLocalizedString(@"ISee", @"我知道了") otherButtonTitles:nil, nil];
    [alert show];
}
- (void)selectChange{
    
    int n = _collectionView.contentOffset.x / SCREEN_WIDTH;
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    if (!_selectModels[n].isselected) {
        if (nav.leftNumber != 0 && nav.leftNumber > _realSelect.count) {
            [_selectBtn setImage:[UIImage imageNamed:@"album_imagepick_choosed"] forState:UIControlStateNormal];
            [_realSelect addObject:_selectModels[n]];
        } else {
            [self outOfNumber];
            return;
        }
        
    } else {
        if ([_realSelect containsObject:_selectModels[n]]) {
            [_selectBtn setImage:[UIImage imageNamed:@"album_imagepick_unchoose"] forState:UIControlStateNormal];
            [_realSelect removeObject:_selectModels[n]];
        } else {
            return;
        }
    }
    _selectModels[n].isselected = !_selectModels[n].isselected;
    [self refreshBottom];
}
- (void)refreshBottom{
    _countLabel.text = [NSString stringWithFormat:@"%zd",_realSelect.count];
    if (_realSelect.count > 0) {
        _circle.hidden = NO;
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x09cc9f] forState:UIControlStateNormal];
        _completeBtn.userInteractionEnabled = YES;
    } else {
        _circle.hidden = YES;
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x7f7f7f] forState:UIControlStateNormal];
        _completeBtn.userInteractionEnabled = NO;
    }
}
- (void)completeClick:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    sender.selected = YES;
    __block typeof(self)weakSelf = self;
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    if (_realSelect.count <= nav.maxImageNumber) {
        NSMutableArray *photos = [NSMutableArray array];
        for (NSInteger i = 0; i < _realSelect.count; i++) {
            [photos addObject:@1];
        }
        for (int i = 0;i < _realSelect.count;i++) {
            LMDAssetModel *model = _realSelect[i];
            [[LMDPhotosManager sharedInstance]getOriginalPhotoDataWithAsset:model.asset completion:^(NSData *data, NSDictionary *info) {
                [photos replaceObjectAtIndex:i withObject:data];
                for (id item in photos) {
                    if ([item isKindOfClass:[NSNumber class]]) {
                        return;
                    }
                }
                [weakSelf getAllPhotosDone:photos andAssets:nil];
            }];
        }
    }
}

- (void)getAllPhotosDone:(NSMutableArray *)photos andAssets:(NSArray *)assets{
    [[LMDPhotosManager sharedInstance]writeToFileWithArray:photos andCompletion:^(NSArray *paths) {
        [self readyToSend:paths];
    }];
}

- (void)readyToSend:(NSArray *)paths{
    dispatch_async(dispatch_get_main_queue(), ^{
        LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
        if ([nav.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:)]) {
            [nav.pickerDelegate imagePickerController:nav didFinishPickingPhotos:paths];
        }
        [self dismiss];
    });
}

- (void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMDPhotoPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[LMDPhotoPreviewCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    }
    cell.model = _selectModels[indexPath.row];
    __block typeof(self)weakSelf = self;
    cell.singleImageBlock = ^(){
        [weakSelf hideOrShowTopAndBottom];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [(LMDPhotoPreviewCollectionViewCell *)cell recoverSubViews];
    if (_selectModels[indexPath.row].isselected) {
        [_selectBtn setImage:[UIImage imageNamed:@"album_imagepick_choosed"] forState:UIControlStateNormal];
    } else {
        [_selectBtn setImage:[UIImage imageNamed:@"album_imagepick_unchoose"] forState:UIControlStateNormal];
    }
}
#pragma mark lazy load
- (void)setCurrentShow:(NSInteger)currentShow{
    _currentShow = currentShow;
    _indexPath = [NSIndexPath indexPathForRow:currentShow inSection:0];
    
}
- (void)hideOrShowTopAndBottom{
    if (!_hideViews) {
        [UIView animateWithDuration:0.25 animations:^{
            [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dumyStatusBar.mas_bottom).offset(-44);
            }];
            [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(44);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dumyStatusBar.mas_bottom);
            }];
            [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
            }];
            [self.view layoutIfNeeded];
        }];
    }
    _hideViews = !_hideViews;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        CGSize itemsize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        layout.itemSize = itemsize;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.scrollsToTop = NO;
        
        [_collectionView registerClass:[LMDPhotoPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"collectioncell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentSize = CGSizeMake(_selectModels.count * self.view.frame.size.height, 0);
    }
    return _collectionView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor colorWithRGB:0x404040];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImageNormal = [UIImage imageNamed:@"album_preview_backarrow"];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [backBtn setImage:[backImageNormal stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backBtn];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"album_imagepick_choosed"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectChange) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_selectBtn];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView).offset(6);
            make.centerY.equalTo(_topView);
            make.height.equalTo(_topView).offset(20);
            make.width.equalTo(@(50));
        }];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.right.equalTo(_topView).offset(-10);
        }];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithRGB:0x404040];
        
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_completeBtn setTitle:NSLocalizedString(@"Completed", @"完成") forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x7f7f7f] forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomView addSubview:_completeBtn];
        
        _circle = [[UIView alloc]init];
        _circle.backgroundColor = [UIColor colorWithRGB:0x09cc9f];
        _circle.layer.cornerRadius = 9;
        [_bottomView addSubview:_circle];
        
        _countLabel = [[UILabel alloc]init];
        _countLabel.text = [NSString stringWithFormat:@"%zd", _realSelect.count];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        [_circle addSubview:_countLabel];
        
        [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView).offset(-12);
            make.centerY.equalTo(_bottomView);
        }];
        
        [_circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_completeBtn.mas_left).offset(-8);
            make.width.height.equalTo(@18);
            make.centerY.equalTo(_bottomView);
        }];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_circle);
        }];
        _circle.hidden = YES;
    }
    return _bottomView;
}

@end
