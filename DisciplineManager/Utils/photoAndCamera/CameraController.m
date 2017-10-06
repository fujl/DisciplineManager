//
//  CustomUIImagePickerController.m
//  PhonePlus
//
//  Created by lihuan on 12-11-26.
//  Copyright (c) 1012年 LongMaster Inc. All rights reserved.
//

#import "CameraController.h"
#import "UIViewExtend.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
//#import "Constants.h"
//#import "CommonAccessIO.h"
#define BottomBg_Height                     150
//#define BottomBg_Height                     100
#define FlashButton_HeightMargin            6
#define FlashButton_Height                  40
#define FlashButton_Width                   40
#define MarginFlashButton                   10
#define AnimateTime                         0.25
@interface CameraController ()
{
    BOOL _isOpen;
}

@end


@implementation CameraController

@synthesize cameraDelegate;
@synthesize hiddenPhotoBtn;
@synthesize useFrontCamera;


-(id)init{
    if (self=[super init]) {
        _isOpen = NO;
        _swithButton=nil;
        _takeImageView=nil;
        _flashButtonAuto=nil;
        _flashButtonOpen=nil;
        _flashButtonClose=nil;
        super.sourceType=UIImagePickerControllerSourceTypeCamera;
        //设配方向改变通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
//        CommonAccessIO* flashAccess = [[CommonAccessIO alloc]init];
//        _flashType = [flashAccess readFlashType];
//        [flashAccess release];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    //    if (IOS7) {
    //        [super viewWillAppear:animated];
    //
    //        super.delegate=self;
    //
    //        return;
    //    }
    //定制照相界面。
    if (true || super.sourceType==UIImagePickerControllerSourceTypeCamera) {
        super.delegate=self;
        //        super.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:super.sourceType];
        super.hidesBottomBarWhenPushed=YES;
        super.navigationBarHidden=YES;
        super.toolbarHidden=YES;
        super.allowsEditing=YES;
        //设置是否隐藏所有的标准的UI界面，默认是YES，(代表是用标准的UI界面)
        super.showsCameraControls=NO;
        
        /*****顶部视图***/
        AVCaptureDevice* d = nil;
        NSArray* allDevices = [AVCaptureDevice devices];
        for (AVCaptureDevice* currentDevice in allDevices) {
            if (currentDevice.position == AVCaptureDevicePositionBack) {
                d = currentDevice;
                break;
            }
        }
        //顶部背景 add by wf
        
        _topBackImg = [[UIView alloc] init];
        _topBackImg.backgroundColor = [UIColor blackColor];
        if (IPHONE5) {
            _topBackImg.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
        } else {
            _topBackImg.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        }
        
        [super.cameraOverlayView addSubview:_topBackImg];
        
        //设备具有闪光灯功能才显示按钮。
        if ([d isFlashModeSupported:AVCaptureFlashModeOn]) {
            if (!_flashType) {
//                CommonAccessIO* flashAccess = [[CommonAccessIO alloc]init];
//                [flashAccess writeFlashType:0];
//                [flashAccess release];
                _flashType = 0;
            }
            //添加<闪光灯>按钮
            _flashImage = [[UIImageView alloc]init];
            _flashImage.frame = CGRectMake(11, 14, 15, 23);
            _flashImage.image =[UIImage imageNamed:@"comm_camera_flash_off"];
            [_topBackImg addSubview:_flashImage];
            
            
            _flashButtonAuto = [[UIButton alloc]init];
            _flashButtonAuto.frame = CGRectMake(35, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            [_flashButtonAuto addTarget:self action:@selector(flashButton_click:) forControlEvents:UIControlEventTouchUpInside];
            _flashButtonAuto.tag = 1001;
            _flashButtonAuto.backgroundColor=[UIColor blackColor];
            [_flashButtonAuto setTitleColor:[UIColor colorWithRGB:0xffcc00] forState:UIControlStateNormal];
            [_flashButtonAuto setTitle:@"自动" forState:UIControlStateNormal];
            [_topBackImg addSubview:_flashButtonAuto];
            
            
            
            _flashButtonOpen = [[UIButton alloc]init];
            _flashButtonOpen.frame = CGRectMake(CGRectGetMaxX(_flashButtonAuto.frame)+MarginFlashButton, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            [_flashButtonOpen addTarget:self action:@selector(flashButton_click:) forControlEvents:UIControlEventTouchUpInside];
            _flashButtonOpen.tag = 1002;
            _flashButtonOpen.backgroundColor=[UIColor blackColor];
            [_flashButtonOpen setTitleColor:[UIColor colorWithRGB:0xffcc00] forState:UIControlStateNormal];
            [_flashButtonOpen setTitle:@"打开" forState:UIControlStateNormal];
            [_topBackImg addSubview:_flashButtonOpen];
            
            
            
            _flashButtonClose = [[UIButton alloc]init];
            _flashButtonClose.frame = CGRectMake(CGRectGetMaxX(_flashButtonOpen.frame)+MarginFlashButton, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            [_flashButtonClose addTarget:self action:@selector(flashButton_click:) forControlEvents:UIControlEventTouchUpInside];
            _flashButtonClose.tag = 1003;
            _flashButtonClose.backgroundColor=[UIColor blackColor];
            [_flashButtonClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_flashButtonClose setTitle:@"关闭" forState:UIControlStateNormal];
            [_topBackImg addSubview:_flashButtonClose];
            [self afreshFlashBtnFrame:_flashType];
        }
        //设备具有切换功能才显示按钮。
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]
            && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            //添加摄像头前后<切换>按钮
            UIImage *image = [UIImage imageNamed:@"comm_camera_change_norm"];//[[SkinManager sharedSkinManager] getImageForKey:@"comm_camera_change_norm"];
            _swithButton=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, IPHONE5?20:0, 60, 50)];
            [_swithButton setImage:image forState:UIControlStateNormal];
            [_swithButton addTarget:self action:@selector(swithButton_click) forControlEvents:UIControlEventTouchUpInside];
            [_topBackImg addSubview:_swithButton];
            //设置默认摄像头
            if (useFrontCamera) {
                super.cameraDevice=UIImagePickerControllerCameraDeviceFront;
            }
        }
        /*****底部视图***/
        
        //背景
        //        UIImageView *bgImageView = [[UIImageView alloc] init/*WithImageForKey:@"comm_camera_bottom_bg"*/];
        //        bgImageView.image = [UIImage imageNamed:@"comm_camera_bottom_bg"];
        //        bgImageView.frame=CGRectMake(0, SCREEN_HEIGHT-BottomBg_Height/2, SCREEN_WIDTH, BottomBg_Height/2);
        //        [super.cameraOverlayView addSubview:bgImageView];
        //        [bgImageView release];
        UIView* bgImageView = [[UIView alloc]init];
        bgImageView.backgroundColor = [UIColor blackColor];
        if (IPHONE5) {
            bgImageView.frame=CGRectMake(0, SCREEN_HEIGHT-BottomBg_Height/2-50, SCREEN_WIDTH, BottomBg_Height/2-50);
        } else {
            bgImageView.frame=CGRectMake(0, SCREEN_HEIGHT-BottomBg_Height/2, SCREEN_WIDTH, BottomBg_Height/2);
        }
        
        [super.cameraOverlayView addSubview:bgImageView];
        [bgImageView release];
        
        UIImage* maskImg = [UIImage imageNamed:(IPHONE5 || IPHONE6)?@"cutpicmask1136":@"cutpicmask"];
        
        //添加<取消>摄像按钮
        UIImage *cancelImage = [UIImage imageNamed:@"comm_camera_cancel_button_norm"];//[[SkinManager sharedSkinManager] getImageForKey:@"blog_post_filter_recapture_norm"];
        UIButton *cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-BottomBg_Height/4-cancelImage.size.height/2, cancelImage.size.width, cancelImage.size.height)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        //        [cancelButton setImage:cancelImage forState:UIControlStateNormal];
        //        [cancelButton setImage:[UIImage imageNamed:@"comm_camera_cancel_button_pres"] forState:UIControlStateHighlighted];
        //        [cancelButton setImageForKey:@"blog_post_filter_recapture_pres" forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(cancelButton_click) forControlEvents:UIControlEventTouchUpInside];
        [super.cameraOverlayView addSubview:cancelButton];
        [cancelButton release];
        
        
        //添加<照相>按钮
        UIImage *takeImageBg = [UIImage imageNamed:@"comm_camera_takebg_norm"];//[[SkinManager sharedSkinManager] getImageForKey:@"comm_camera_takebg_norm"];
        UIButton *takeButtonBg=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-takeImageBg.size.width)/2.0, SCREEN_HEIGHT-BottomBg_Height/4-takeImageBg.size.height/2, takeImageBg.size.width, takeImageBg.size.height)];
        [takeButtonBg setImage:takeImageBg forState:UIControlStateNormal];
        [takeButtonBg setImage:[UIImage imageNamed:@"comm_camera_takebg_pres"] forState:UIControlStateHighlighted];
        //        [takeButtonBg setImageForKey:@"comm_camera_takebg_pres" forState:UIControlStateHighlighted];
        [takeButtonBg addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [super.cameraOverlayView addSubview:takeButtonBg];
        [takeButtonBg release];
        
        
        if (hiddenPhotoBtn==NO) {
            //添加<相册>按钮
            UIImage *photoImage = [UIImage imageNamed:@"comm_camera_photo_norm"];//[[SkinManager sharedSkinManager] getImageForKey:@"comm_camera_photo_norm"];
            UIButton *photoButton=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-photoImage.size.width, SCREEN_HEIGHT-BottomBg_Height/4-photoImage.size.height/2, photoImage.size.width, photoImage.size.height)];
            [photoButton setImage:photoImage forState:UIControlStateNormal];
            [photoButton setImage:[UIImage imageNamed:@"comm_camera_photo_pres"] forState:UIControlStateHighlighted];
            //            [photoButton setImageForKey:@"comm_camera_photo_pres" forState:UIControlStateHighlighted];
            [photoButton addTarget:self action:@selector(photoButton_click) forControlEvents:UIControlEventTouchUpInside];
            [super.cameraOverlayView addSubview:photoButton];
            [photoButton release];
        }
    }
    [super viewWillAppear:animated];

    [self orientationDidChange];

//长屏（大于480）设备显示相机时，底部黑色背景视图很高，需要调整到产品部规定的高度。
    if (SCREEN_HEIGHT>480) {
        for (UIView *view in self.view.subviews) {
            view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+(SCREEN_HEIGHT-480)-BottomBg_Height/2+8);//+8为微调结果。
        }
    }
}


-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ( navigationController.viewControllers.count == 1 && viewController) {
        if ([navigationController isKindOfClass:[UIImagePickerController class]]
            && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeCamera) {
            [UIView animateWithDuration:1 animations:^(){
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            } ];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //是否有访问相机的权限
    if (IOS7) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusAuthorized) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            NSString *msgInfo = [NSString stringWithFormat:@"你还没有设置\"%@\"访问相机的权限，请到\"隐私-相机-%@\"中开启。", appName, appName];
            if (IOS8) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:msgInfo preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:action1];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                                message:msgInfo
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"知道了", nil];
                [alertView show];
                [alertView release];
            }
            return;
        }
    }
}



//即使在这里增加对状态栏的恢复，当视图消失时，依然会闪出一下白条，故放在外面控制。
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark
#pragma mark 按钮事件

///<>按钮点击事件
-(void)flashButton_click:(id)sender{
    UIButton* btn = sender;
//    CommonAccessIO* access = [[CommonAccessIO alloc]init];
//    switch (btn.tag) {
//        case 1001:
//        {
//            super.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
//            [access writeFlashType:0];
//            _flashType = 0;
//        }
//            break;
//        case 1002:
//        {
//            super.cameraFlashMode=UIImagePickerControllerCameraFlashModeOn;
//            [access writeFlashType:1];
//            _flashType = 1;
//        }
//            break;
//        case 1003:
//        {
//            super.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
//            [access writeFlashType:2];
//            _flashType = 2;
//        }
//            break;
//        default:
//            LogInfo(@"系统出现了未知异常！");
//            break;
//    }
//    [access release];
    [self afreshFlashBtnFrame:_flashType];
}

//摄像头前后<切换>按钮点击事件
-(void)swithButton_click{
    if (super.cameraDevice==UIImagePickerControllerCameraDeviceRear) {
        super.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    }else{
        super.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    }
    
    //self.cameraViewTransform = CGAffineTransformMakeRotation(M_PI * 2);//以后用。
}

//<取消>按钮点击事件
-(void)cancelButton_click{
    if ([self.cameraDelegate respondsToSelector:@selector(cameraControllerDidCancel:)]) {
        [self.cameraDelegate cameraControllerDidCancel:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//<相册>按钮点击事件
-(void)photoButton_click{
    if ([self.cameraDelegate respondsToSelector:@selector(cameraControllerDidPhoto:)]) {
        [self.cameraDelegate cameraControllerDidPhoto:self];
    }
}

//ios4,5  本方法没有被调用，可能是被上层捕获了。采用直接注册监听器（观察者模式）。
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations.
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

////ios6
//- (BOOL)shouldAutorotate{
//    LogInfo(@"aaaa");
//    return YES;
//}

//ios6
//- (NSUInteger)supportedInterfaceOrientations
//{}

//设备方向发生改变后触发。
-(void)orientationDidChange{
    UIDevice *device = [UIDevice currentDevice] ;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            NSLog(@"向上");
            [self setViewForOrientationUp];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"向左");
            [self setViewForOrientationLeft];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"向右");
            [self setViewForOrientationRight];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"向下");
            [self setViewForOrientationDown];
            break;
            
        default:
            NSLog(@"无法辨认");
            break;
    }
}

//设置正面朝上状态。
-(void)setViewForOrientationUp{
    _swithButton.transform = CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:0.3 animations:^{_takeImageView.transform = CGAffineTransformMakeRotation(0);}];
    
    //    [flashButton setOriginX:10 withOriginY:11];
    //    [swithButton setOriginX:SCREEN_WIDTH-10-swithButton.frame.size.width withOriginY:11];
    [_swithButton setOriginX:SCREEN_WIDTH-0-_swithButton.frame.size.width withOriginY:0];
}

//设置设备向左横着的状态。
-(void)setViewForOrientationLeft{
    _swithButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    [UIView animateWithDuration:0.3 animations:^{_takeImageView.transform = CGAffineTransformMakeRotation(M_PI_2);}];
    
    //    [flashButton setOriginX:SCREEN_WIDTH-10-flashButton.frame.size.width withOriginY:11];
    //    [swithButton setOriginX:SCREEN_WIDTH-10-swithButton.frame.size.width withOriginY:SCREEN_HEIGHT-BottomBg_Height/2-11-swithButton.frame.size.height];
    [_swithButton setOriginX:SCREEN_WIDTH-_swithButton.frame.size.width withOriginY:SCREEN_HEIGHT-BottomBg_Height/2-0-_swithButton.frame.size.height];
}

//设置设备向右横着的状态。
-(void)setViewForOrientationRight{
//    flashButton.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    _swithButton.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [UIView animateWithDuration:0.3 animations:^{_takeImageView.transform = CGAffineTransformMakeRotation(M_PI_2*3);}];
    
    //    [flashButton setOriginX:11 withOriginY:SCREEN_HEIGHT-BottomBg_Height/2-10-flashButton.frame.size.height];
    //    [swithButton setOriginX:11 withOriginY:10];

    [_swithButton setOriginX:0 withOriginY:0];
}

//设置设备上下颠倒的状态。
-(void)setViewForOrientationDown{
//    flashButton.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    _swithButton.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    [UIView animateWithDuration:0.3 animations:^{_takeImageView.transform = CGAffineTransformMakeRotation(M_PI_2*2);}];
    
//    [flashButton setOriginX:SCREEN_WIDTH-0-flashButton.frame.size.width withOriginY:SCREEN_HEIGHT-BottomBg_Height/2-0-flashButton.frame.size.height];
    [_swithButton setOriginX:0 withOriginY:SCREEN_HEIGHT-BottomBg_Height/2-0-_swithButton.frame.size.height];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"])			{
        //图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image && [self.cameraDelegate respondsToSelector:@selector(cameraController:didFinishImage:)]) {
            [self.cameraDelegate cameraController:self didFinishImage:image];
            return;
        }
    }
    else if([mediaType isEqualToString:@"public.movie"]){
        //视频
        NSLog(@"mediaType is public.movie");
    }
    else{
        NSLog(@"Error media type");
    }
    
    if ([self.cameraDelegate respondsToSelector:@selector(cameraController:onError:)]) {
        [self.cameraDelegate cameraController:self onError:@"相机参数配置可能不正确！"];
    }
}
//改变闪关灯 选项按钮位置
- (void)afreshFlashBtnFrame:(int) index
{
    if (!_isOpen) {
        switch (index) {
            case 0:
            {
                super.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
                _flashImage.image = [UIImage imageNamed:@"comm_camera_flash_on"];
                [super.cameraOverlayView addSubview:_flashButtonAuto];
                
            }
                break;
            case 1:
            {
                super.cameraFlashMode=UIImagePickerControllerCameraFlashModeOn;
                _flashImage.image = [UIImage imageNamed:@"comm_camera_flash_on"];
                [super.cameraOverlayView addSubview:_flashButtonOpen];
                
            }
                break;
            case 2:
            {
                super.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
                _flashImage.image = [UIImage imageNamed:@"comm_camera_flash_off"];
                [super.cameraOverlayView addSubview:_flashButtonClose];
            }
                break;
            default:
                break;
        }
        [UIView animateWithDuration:AnimateTime animations:^{
            _flashButtonAuto.frame = CGRectMake(35, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            _flashButtonOpen.frame = CGRectMake(35, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            _flashButtonClose.frame = CGRectMake(35, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
        }];
        _isOpen = YES;
        
    } else {
        [UIView animateWithDuration:AnimateTime animations:^{
            _flashButtonAuto.frame = CGRectMake(35, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            _flashButtonOpen.frame = CGRectMake(CGRectGetMaxX(_flashButtonAuto.frame)+MarginFlashButton, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
            _flashButtonClose.frame = CGRectMake(CGRectGetMaxX(_flashButtonOpen.frame)+MarginFlashButton, FlashButton_HeightMargin, FlashButton_Width, FlashButton_Height);
        }];
        _isOpen = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_RELEASE(_flashButtonAuto);
    SAFE_RELEASE(_flashButtonOpen);
    SAFE_RELEASE(_flashButtonClose);
    SAFE_RELEASE(_swithButton);
    SAFE_RELEASE(_flashImage);
    SAFE_RELEASE(_topBackImg);
    SAFE_RELEASE(_takeImageView);
    
    [super dealloc];
    

}

@end
