//
//  LMDAlbumPickerViewController.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDAlbumPickerViewController.h"
#import "LMDPhotoPickerViewController.h"
#import "LMDPhotosManager.h"
#import "LMDAlbumListCell.h"
#define kAlertAuthorized 3000

@interface LMDAlbumPickerViewController ()

@end

@implementation LMDAlbumPickerViewController

#pragma mark - cycle life

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<LMDImagePickerDelegate>)delegate {
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:delegate pushPhotoPickerVC:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<LMDImagePickerDelegate>)delegate {
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber delegate:delegate pushPhotoPickerVC:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<LMDImagePickerDelegate>)delegate pushPhotoPickerVC:(BOOL)pushPhotoPickerVC {
    LMDAlbumListViewController *listVC = [[LMDAlbumListViewController alloc] init];
    self = [super initWithRootViewController:listVC];
    if (self) {
        self.selectedModels = [[NSMutableArray alloc] init];
        self.maxImageNumber = maxImagesCount > 0 ? maxImagesCount : 9;
        self.leftNumber = self.maxImageNumber;
        self.pickerDelegate = delegate;
        if (pushPhotoPickerVC) {
            LMDPhotoPickerViewController *pickerVC = [[LMDPhotoPickerViewController alloc] init];
            [[LMDPhotosManager sharedInstance] getCameraRollAlbumWithCompletion:^(LMDAlbumModel *model) {
                pickerVC.album = model;
                pickerVC.columnNumber = columnNumber;
                if (model.count != 0) {
                    [self pushViewController:pickerVC animated:NO];
                }
            }];
        }
    }
    return self;
}

- (void)setSelectedAssets:(NSArray *)selectedAssets {
    _selectedAssets = selectedAssets;
    _selectedModels = [NSMutableArray array];
    for (PHAsset *asset in _selectedAssets) {
        LMDAssetModel *model = [LMDAssetModel modelWithAsset:asset andType:AssetModelTypePhoto];
        model.isselected = YES;
        [_selectedModels addObject:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    LMDUserManager *manager = getManager(LMDUserManager);
//    [manager.pes addPESLineStateChangeDelegate:self];
}

- (void)dealloc {
//    LMDUserManager *manager = getManager(LMDUserManager);
//    [manager.pes removePESLineStateChangeDelegate:self];
}

#pragma mark - PESLineStateChangeDelegate
//- (void)PESLineStateChange:(LMDPESOnlineState)newLineState {
//    if (newLineState == LMDPESOnlineStateKickoff) {
//        UIViewController *vc =  self;
//        while (vc.presentingViewController) {
//            vc = vc.presentingViewController;
//        }
//        [vc dismissViewControllerAnimated:NO completion:nil];
//    }
//}

@end

@interface LMDAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *albumArray;

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) NSMutableArray *selectModels;
@end

@implementation LMDAlbumListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Photo", @"照片");
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"cancel", @"取消") style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = cancel;
    
    [self setLeftBar];
    [self authorizedCheck];
    
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
    [btnBack addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = item;
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
                    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
                    _selectModels = nav.selectedModels;
                    [self initEmptyView];
                    [[LMDPhotosManager sharedInstance] getAllAlbumsWithCompletion:^(NSMutableArray<LMDAlbumModel *> *models) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.columnNumber = nav.maxImageNumber;
                            _albumArray = [NSMutableArray arrayWithArray:models];
                            if ([self emptyCheck]) {
                                [_emptyView removeFromSuperview];
                            } else {
                                [self configTableView];
                            }
                        });
                    }];
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
        {
            LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
            _selectModels = nav.selectedModels;
            [self initEmptyView];
            [[LMDPhotosManager sharedInstance] getAllAlbumsWithCompletion:^(NSMutableArray<LMDAlbumModel *> *models) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.columnNumber = nav.maxImageNumber;
                    _albumArray = [NSMutableArray arrayWithArray:models];
                    if ([self emptyCheck]) {
                        [_emptyView removeFromSuperview];
                    } else {
                        [self configTableView];
                    }
                });
            }];
        }
        default:
        {
            break;
        }
    }
}

- (BOOL)emptyCheck {
    BOOL isEmpty = YES;
    for (LMDAlbumModel *model in _albumArray) {
        if (model.models.count != 0) {
            isEmpty = NO;
            break;
        }
    }
    return isEmpty;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.refreshModel) {
        [self needRefreshModel];
    }
}

- (void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initEmptyView{
    _emptyView = [[UIView alloc] init];
    _emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"album_empty"]];
    [_emptyView addSubview:imageView];
    
    UILabel *tipLabelOne = [[UILabel alloc]init];
    
    tipLabelOne.textColor = [UIColor colorWithRGB:0x7f7f7f];
    tipLabelOne.font = [UIFont systemFontOfSize:12];
    tipLabelOne.textAlignment = NSTextAlignmentCenter;
    tipLabelOne.text = NSLocalizedString(@"album_nodata_tipone", @"当前没有照片");
    [_emptyView addSubview:tipLabelOne];
    
    UILabel *tipLabelTwo = [[UILabel alloc]init];
    tipLabelTwo.textColor = [UIColor colorWithRGB:0x7f7f7f];
    tipLabelTwo.font = [UIFont systemFontOfSize:10];
    tipLabelTwo.textAlignment = NSTextAlignmentCenter;
    tipLabelTwo.text = NSLocalizedString(@"album_nodata_tiptwo", @"使用相机拍摄");
    [_emptyView addSubview:tipLabelTwo];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_emptyView);
        make.centerY.equalTo(_emptyView).offset(-40);
    }];
    
    [tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(8);
        make.centerX.equalTo(_emptyView);
    }];
    
    [tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_emptyView);
        make.top.equalTo(tipLabelOne.mas_bottom).offset(6);
    }];
}
- (void)configTableView{
    LMDAlbumPickerViewController *nav = (LMDAlbumPickerViewController *)self.navigationController;
    if (self.refreshModel) {
        [self needRefreshModel];
    }
    for (LMDAlbumModel *model in _albumArray) {
        model.selectModels = nav.selectedModels;
    }
    if (!_mainTable) {
        [self.view addSubview:self.mainTable];
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        [_mainTable reloadData];
    }
}

- (UITableView *)mainTable{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc]init];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTable registerClass:[LMDAlbumListCell class] forCellReuseIdentifier:@"cellid"];
        _mainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _mainTable;
}
#pragma mark funcs
- (void)needRefreshModel{
    for (int i = 0; i < _albumArray.count;i++) {
        LMDAlbumModel *model = _albumArray[i];
        if ([model.name isEqualToString:_refreshModel.name]) {
            [_albumArray replaceObjectAtIndex:i withObject:_refreshModel];
            _refreshModel = nil;
            break;
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kAlertAuthorized) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMDAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    if (!cell) {
        cell = [[LMDAlbumListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _albumArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LMDPhotoPickerViewController *vc = [[LMDPhotoPickerViewController alloc]init];
    vc.columnNumber = self.columnNumber;
    LMDAlbumModel *model = _albumArray[indexPath.row];
    vc.album = model;
    vc.selectModels = _selectModels;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
