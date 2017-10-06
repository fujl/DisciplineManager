//
//  LMDPhotoPickerViewController.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDPhotoPickerViewController.h"
#import "LMDAlbumPickerViewController.h"
#import <Photos/Photos.h>
#import "LMDPhotoPickCollectionViewCell.h"
#import "LMDPhotoPreviewViewController.h"
#import "LMDPhotosManager.h"

#define kAlertAuthorized        2000
@interface LMDPhotoPickerViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) UICollectionView *mainCollection;
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIView *circle;

@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation LMDPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _album.name;
    _columnNumber = 3;
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    _selectModels = nav.selectedModels;
    
    _models = [NSMutableArray arrayWithArray:_album.models];
    [self authorizedCheck];
    [self checkSelectedModels];
    [self setLeftBar];
    [self setUpViews];
    [self layoutViews];
    [self refresh];
}
- (void)authorizedCheck{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    // 用户同意授权
                }else {
                    // 用户拒绝授权
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            break;
        }
        case PHAuthorizationStatusRestricted:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        case PHAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hint", @"提示") message:NSLocalizedString(@"photo_authorized", @"请在iPhone的\"设置-隐私-照片\"中允许访问照片。") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles:nil];
            alert.tag = kAlertAuthorized;
            [alert show];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            break;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    _selectModels = nav.selectedModels;
    [_mainCollection reloadData];
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    nav.selectedModels = _selectModels;
    
    LMDAlbumListViewController *vc = (LMDAlbumListViewController *)nav.childViewControllers[0];
    vc.refreshModel = _album;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kAlertAuthorized) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)setUpViews{
    [self.view addSubview:self.mainCollection];
    [self.view addSubview:self.controlView];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"cancel",  @"取消") style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = cancel;
}
- (void)layoutViews{
    [_mainCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_mainCollection.mas_bottom);
        make.height.equalTo(@44);
    }];
}

- (void)setLeftBar{
    self.navigationItem.leftBarButtonItem = nil;
    UIImage *backImageNormal = [UIImage imageNamed:@"GoBack"];
    UIImage *backImagePress = [UIImage imageNamed:@"album_preview_backarrow"];
    UIButton *btnBack = [[UIButton alloc] init];
    [btnBack setExclusiveTouch:YES];
    btnBack.frame = CGRectMake(0, 0, backImageNormal.size.width+20, backImageNormal.size.height+20);
    [btnBack setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [btnBack setImage:[backImageNormal stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5] forState:UIControlStateNormal];
    [btnBack setImage:[backImagePress stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)goBack{
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    nav.selectedModels = _selectModels;
    
    LMDAlbumListViewController *vc = (LMDAlbumListViewController *)nav.childViewControllers[0];
    vc.refreshModel = _album;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark lazy load
- (UICollectionView *)mainCollection{
    if (!_mainCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 4;
        CGSize itemsize = CGSizeMake((self.view.frame.size.width - (_columnNumber-1)*4) / _columnNumber, (self.view.frame.size.width - (_columnNumber+1)*4) / _columnNumber);
        layout.itemSize = itemsize;
        
        _mainCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainCollection.delegate = self;
        _mainCollection.dataSource = self;
        [_mainCollection registerClass:[LMDPhotoPickCollectionViewCell class] forCellWithReuseIdentifier:@"collectionId"];
        _mainCollection.backgroundColor = [UIColor whiteColor];
    }
    return _mainCollection;
}

- (UIView *)controlView{
    if (!_controlView) {
        _controlView = [[UIView alloc]init];
        _controlView .backgroundColor = [UIColor whiteColor];
        
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:NSLocalizedString(@"Preview",  @"预览") forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _previewBtn.userInteractionEnabled = NO;
        [_previewBtn setTitleColor:[UIColor colorWithRGB:0x7f7f7f alpha:0.6] forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(previewClick) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:_previewBtn];
        
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:NSLocalizedString(@"Completed", @"完成") forState:UIControlStateNormal];
        _completeBtn.userInteractionEnabled = NO;
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x7f7f7f alpha:0.6] forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:_completeBtn];
        
        _circle = [[UIView alloc]init];
        _circle.backgroundColor = [UIColor colorWithRGB:0x09cc9f];
        _circle.layer.cornerRadius = 9;
        [_controlView addSubview:_circle];
        
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.text = @"0";
        [_circle addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_circle);
            make.width.height.equalTo(@15);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
        [_controlView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_controlView);
            make.height.equalTo(@0.5);
        }];
        
        [_previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_controlView).offset(15);
            make.centerY.height.equalTo(_controlView);
            make.width.equalTo(@50);
        }];
        
        [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(_controlView);
            make.right.equalTo(_controlView).offset(-12);
            make.width.equalTo(@40);
        }];
        [_circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_controlView);
            make.right.equalTo(_completeBtn.mas_left);
            make.width.height.equalTo(@18);
        }];
        _circle.hidden = YES;
    }
    return _controlView;
}

#pragma mark funcs
- (void)checkSelectedModels {
    NSMutableArray *selectedAssets = [NSMutableArray array];
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    for (LMDAssetModel *model in nav.selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    
    for (LMDAssetModel *model in _models) {
        model.isselected = NO;
        if ([selectedAssets containsObject:model.asset]) {
            model.isselected = YES;
        }
    }
}
- (void)outOfNumber{
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"photo_maxnumber", @"您最多只能选择%ld张照片"),nav.maxImageNumber] delegate:self cancelButtonTitle:NSLocalizedString(@"ISee", @"我知道了") otherButtonTitles:nil, nil];
    [alert show];
}
- (void)cellSelect:(NSInteger)item{
    __weak typeof(self)weakSelf = self;
    LMDAssetModel *asset = _models[item];
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    //选中
    if (asset.isselected) {
        [self compareAsset:asset andArray:_selectModels andBLock:^(BOOL contain, LMDAssetModel *AssetModel) {
            if (!contain) {
                if (nav.leftNumber != 0 && _selectModels.count < nav.leftNumber) {
                    [weakSelf.selectModels addObject:asset];
                } else {
                    [weakSelf cellOutOfNumber:item];
                    return;
                }
            }
        }];
    } else {
        //撤销
        [self compareAsset:asset andArray:_selectModels andBLock:^(BOOL contain, LMDAssetModel *AssetModel) {
            if (contain) {
                [weakSelf.selectModels removeObject:AssetModel];
            }
        }];
    }
    [self refresh];
}

- (void)cellOutOfNumber:(NSInteger)item{
    LMDPhotoPickCollectionViewCell *cell = (LMDPhotoPickCollectionViewCell *)[_mainCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
    [cell recallIcon];
    [self outOfNumber];
}

- (void)compareAsset:(LMDAssetModel *)compareModel andArray:(NSMutableArray *)models andBLock:(void(^)(BOOL contain,LMDAssetModel *AssetModel))block{
    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LMDAssetModel *model = (LMDAssetModel *)obj;
        if ([model.asset.localIdentifier isEqualToString:compareModel.asset.localIdentifier]) {
            if (block) {
                block(YES,model);
            }
        }
    }];
    if (block) {
        block(NO,nil);
    }
}
- (void)refresh{
    _countLabel.text = [NSString stringWithFormat:@"%zd",_selectModels.count];
    if (_selectModels.count > 0) {
        _circle.hidden = NO;
        
        [_previewBtn setTitleColor:[UIColor colorWithRGB:0x09cc9f] forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x09cc9f] forState:UIControlStateNormal];
        _previewBtn.userInteractionEnabled = YES;
        _completeBtn.userInteractionEnabled = YES;
    } else {
        _circle.hidden = YES;
        [_previewBtn setTitleColor:[UIColor colorWithRGB:0x7f7f7f] forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x7f7f7f] forState:UIControlStateNormal];
        _previewBtn.userInteractionEnabled = NO;
        _completeBtn.userInteractionEnabled = NO;
    }
    
}

- (void)previewClick{
    LMDPhotoPreviewViewController *vc = [[LMDPhotoPreviewViewController alloc]init];
    vc.selectModels = _selectModels;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)completeClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        [self getPhotosByModels:_selectModels];
        return;
    }
}

- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *, NSDictionary *))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData, info);
        }
    }];
}

- (void)getPhotosByModels:(NSArray *)models{
    __block typeof(self)weakSelf = self;
    NSMutableArray *arr = [NSMutableArray array];
    for (LMDAssetModel *model in models) {
        [self getOriginalPhotoDataWithAsset:model.asset completion:^(NSData *data, NSDictionary *info) {
            [arr addObject:data];
            if (arr.count == models.count) {
                [weakSelf getAllPhotosDone:arr andAssets:models];
            }
        }];
    }
}

- (void)getAllPhotosDone:(NSMutableArray *)photos andAssets:(NSArray *)assets{
    [[LMDPhotosManager sharedInstance] writeToFileWithArray:photos andCompletion:^(NSArray *paths) {
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

- (void)showLocalAlbumPreview:(NSInteger)item{
    LMDPhotoPreviewViewController *vc = [[LMDPhotoPreviewViewController alloc]init];
    vc.selectModels = [NSMutableArray arrayWithArray:_album.models];
    vc.currentShow = item;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMDPhotoPickCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionId" forIndexPath:indexPath];
    if (!cell) {
        cell = [[LMDPhotoPickCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width - (_columnNumber+1)*4) / _columnNumber, (self.view.frame.size.width - (_columnNumber+1)*4) / _columnNumber)];
    }
    cell.model = _models[indexPath.row];
    cell.item = indexPath.row;
    __block typeof(self)weakSelf = self;
    cell.selectBlock = ^(NSInteger item){
        [weakSelf cellSelect:item];
    };
    cell.imageClick = ^(NSInteger item){
        [weakSelf showLocalAlbumPreview:item];
    };
    return cell;
}

@end
