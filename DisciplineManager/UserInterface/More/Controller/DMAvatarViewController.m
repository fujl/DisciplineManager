//
//  DMAvatarViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAvatarViewController.h"
#import "LMDAlbumPickerViewController.h"
#import "CameraController.h"
#import "CutAvatarImgViewController.h"
#import "ImageUtil.h"
#import "LMDPhotosManager.h"
#import "DMImageUploadReuester.h"

static const int MAX_IMAGE_COUNT = 1;

@interface DMAvatarViewController () <UIActionSheetDelegate, LMDImagePickerDelegate,CameraControllerDelegate,CutAvatarImgViewControllerDelegate>

@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation DMAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = NSLocalizedString(@"PersonalAvatar", @"个人头像");
    [self addNavRightItem:@selector(clickUpload) andTitle:NSLocalizedString(@"Modify",@"修改")];
    
    [self.view addSubview:self.avatarView];
    
    [self setUserAvatar];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@(SCREEN_WIDTH-20));
    }];
}

- (void)setUserAvatar {
    if ([self.user.userInfo.face isEqualToString:@""]) {
        UIImage *avatar = [UIImage imageNamed:self.user.userInfo.gender == Male ? @"male" : @"female"];
        self.avatarView.image = avatar;
    } else {
        UIImage *avatar = [UIImage imageNamed:self.user.userInfo.gender == Male ? @"male" : @"female"];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, self.user.userInfo.face]] placeholderImage:avatar];
    }
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.userInteractionEnabled = YES;
    }
    return _avatarView;
}

- (void)clickUpload {
    [self showChoosePictureDialog];
}

#pragma mark 选择照片弹窗
- (void)showChoosePictureDialog {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TakePhoto", nil), NSLocalizedString(@"ChooseFromGallery", nil), nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { //拍照
        [self takePhoto];
    } else if (buttonIndex == 1) { //相册
        NSInteger count = MAX_IMAGE_COUNT;
        LMDAlbumPickerViewController *controller = [[LMDAlbumPickerViewController alloc] initWithMaxImagesCount:count delegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - 拍照
- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        showToast(NSLocalizedString(@"你的设备不支持摄像头，请在相册中选择！", nil));
        return ;
    }
    
    CameraController *ctrl = [[CameraController alloc] init];
    ctrl.cameraDelegate = self;
    ctrl.hiddenPhotoBtn = YES;
    ctrl.useFrontCamera = YES;
    [self presentViewController:ctrl animated:YES completion:^(){
        [UIView animateWithDuration:0.5 animations:^(){
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - CameraControllerDelegate
//图片回调。
-(void)cameraController:(CameraController *)camera didFinishImage:(UIImage *)image {
    if(UIImageOrientationUp != image.imageOrientation) {
        image = [ImageUtil AdjustOrientationToUpReturnNew:image];
    }
    CutAvatarImgViewController *cutpic = [[CutAvatarImgViewController alloc] init];
    cutpic.delegate = self;
    cutpic.sourceImage = image;
    cutpic.backImageViewRect = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH);
    //    cutpic.healthType = enumHealthTypeFace;
    [camera pushViewController:cutpic animated:YES];
}

//取消回调。
-(void)cameraControllerDidCancel:(CameraController *)camera {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];//这句话必须放在dismissViewControllerAnimated之前，否则会闪出一下白条。
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CutAvatarImgViewControllerDelegate
-(void)cutImgFinish:(UIImage*)image {
    NSLog(@"图片剪切完成");
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [[LMDPhotosManager sharedInstance] writeToFileWithArray:@[imageData] andCompletion:^(NSArray *photos) {
        for (NSString *path in photos) {
            // 上传
            [self uploadImage:path];
        }
    }];
}

#pragma mark - LMDImagePickerDelegate
- (void)imagePickerController:(LMDAlbumPickerViewController *)picker didFinishPickingPhotos:(NSArray<NSString *> *)photos {
    for (NSString *path in photos) {
        // 上传
        [self uploadImage:path];
    }
}

- (void)uploadImage:(NSString *)filePath {
    DMImageUploadReuester *requester = [[DMImageUploadReuester alloc] init];
    showLoadingDialog();
    [requester upload:filePath callback:^(DMResultCode code, id data) {
        NSDictionary *dataDict = data;
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            NSDictionary *errData = [dataDict objectForKey:@"errData"];
            NSArray *rows = [errData objectForKey:@"rows"];
            for (NSDictionary *itemDict in rows) {
                NSString *path = [itemDict objectForKey:@"path"];
                self.user.userInfo.face = path;
                [self setUserAvatar];
                if (self.userAvatarChange) {
                    self.userAvatarChange();
                }
            }
            NSLog(@"resultString:%@", dataDict);
        } else {
            if (data) {
                NSString *errMsg = [dataDict objectForKey:@"errMsg"];
                showToast(errMsg);
            } else {
                showToast(NSLocalizedString(@"", @""));
            }
        }
    }];
}

@end
