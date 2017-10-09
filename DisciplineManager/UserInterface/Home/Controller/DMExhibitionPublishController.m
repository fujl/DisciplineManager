//
//  DMExhibitionPublishController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhibitionPublishController.h"
#import "MsgInterviewImageContainer.h"
#import "LMDAlbumPickerViewController.h"
#import "CameraController.h"
#import "CutAvatarImgViewController.h"
#import "ImageUtil.h"
#import "LMDPhotosManager.h"
#import "DMImageUploadReuester.h"
#import "DMSubmitExhRequester.h"

static const int MAX_IMAGE_COUNT = 9;

@interface DMExhibitionPublishController () <UIActionSheetDelegate, LMDImagePickerDelegate,CameraControllerDelegate,CutAvatarImgViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMMultiLineTextView *moodTextView;
@property (nonatomic, strong) MsgInterviewImageContainer *imgContainer;
//@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, strong) NSMutableArray *attrArray;

@end

@implementation DMExhibitionPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"FillinExhibition", @"");
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"")];
    
    [self.subviewList addObject:self.moodTextView];
    [self.subviewList addObject:self.imgContainer];
//    [self.subviewList addObject:self.commitView];
    
    [self addChildViews:self.subviewList];
    
    [self setLister];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (NSMutableArray *)attrArray {
    if (!_attrArray) {
        _attrArray = [[NSMutableArray alloc] init];
    }
    return _attrArray;
}

- (DMMultiLineTextView *)moodTextView {
    if (!_moodTextView) {
        _moodTextView = [[DMMultiLineTextView alloc] init];
        _moodTextView.lcHeight = 200;
        [_moodTextView setMaxMultiLineTextLength:200];
        _moodTextView.backgroundColor = [UIColor whiteColor];
        [_moodTextView setPlaceholder:NSLocalizedString(@"mood", @"这一刻心情")];
    }
    return _moodTextView;
}

- (MsgInterviewImageContainer *)imgContainer {
    if (!_imgContainer) {
        _imgContainer = [[MsgInterviewImageContainer alloc] initWithMaxImageCount:MAX_IMAGE_COUNT columns:3 itemMargin:7];
        _imgContainer.lcHeight = (SCREEN_WIDTH / 3) * 3;
    }
    return _imgContainer;
}

//- (DMEntryCommitView *)commitView {
//    if (!_commitView) {
//        _commitView = [[DMEntryCommitView alloc] init];
//        _commitView.lcHeight = 64;
//        //        __weak typeof(self) weakSelf = self;
//        _commitView.clickCommitBlock = ^{
//            NSLog(@"commit");
//            [AppWindow endEditing:YES];
//        };
//    }
//    return _commitView;
//}

- (void)setLister {
    __weak typeof(self) weakSelf = self;
    
    _imgContainer.choosePicture = ^{
        [AppWindow endEditing:YES];
        [weakSelf showChoosePictureDialog];
    };
    
    _imgContainer.empty = ^{
        //        [weakSelf performSelector:@selector(showTipLabel) withObject:nil afterDelay:0.5];
    };
    
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
        NSInteger count = MAX_IMAGE_COUNT - self.imgContainer.pictures.count;
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
    // 显示
//    self.faceImage = image;
//
//    [self refreshView];
    NSData *imageData = UIImagePNGRepresentation(image);
    [[LMDPhotosManager sharedInstance] writeToFileWithArray:@[imageData] andCompletion:^(NSArray *photos) {
        for (NSString *path in photos) {
            [self.imgContainer addItem:path];
        }
    }];
}

#pragma mark - LMDImagePickerDelegate
- (void)imagePickerController:(LMDAlbumPickerViewController *)picker didFinishPickingPhotos:(NSArray<NSString *> *)photos {
    for (NSString *path in photos) {
        [self.imgContainer addItem:path];
        //        self.tipLabel.hidden = YES;
    }
}

#pragma mark - event
- (void)clickPublish {
    NSString *mood = [self.moodTextView getMultiLineText];
    if ([mood isEqualToString:@""]) {
        showToast(NSLocalizedString(@"mood_placeholder", @""));
        return;
    }
    showLoadingDialog();
    if (self.imgContainer.pictures.count > 0) {
        // 上传图片
        [self.attrArray removeAllObjects];
        [self uploadImage:0];
    } else {
        // 直接发布
        [self publishExhibition];
    }
}

#pragma mark - 发布
- (void)publishExhibition {
    DMSubmitExhRequester *requester = [[DMSubmitExhRequester alloc] init];
    requester.content = [self.moodTextView getMultiLineText];
    if (self.attrArray.count > 0) {
        requester.attrs = self.attrArray;
    }
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

#pragma mark - upload image
- (void)uploadImage:(NSInteger)index {
    DMImageUploadReuester *requester = [[DMImageUploadReuester alloc] init];
    NSString *filePath = self.imgContainer.pictures[index];
    [requester upload:filePath isFace:NO callback:^(DMResultCode code, id data) {
        NSDictionary *dataDict = data;
        if (code == ResultCodeOK) {
            // {"errCode":2,"errMsg":"success","errData":{"total":1,"rows":[{"path":"upload/images/201710051324435024.jpg","size":386}]}}
            NSDictionary *errData = [dataDict objectForKey:@"errData"];
            NSArray *rows = [errData objectForKey:@"rows"];
            for (NSDictionary *itemDict in rows) {
                NSString *path = [itemDict objectForKey:@"path"];
                [self.attrArray addObject:@{@"path":path, @"number":@(index)}];
            }
            NSInteger nextIndex = index+1;
            if (nextIndex < self.imgContainer.pictures.count) {
                [self uploadImage:nextIndex];
            } else {
                NSLog(@"上传完成");
                [self publishExhibition];
            }
            NSLog(@"resultString:%@", dataDict);
        } else {
            dismissLoadingDialog();
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
