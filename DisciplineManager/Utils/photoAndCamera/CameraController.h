//
//  CustomUIImagePickerController.h
//  PhonePlus
//
//  Created by lihuan on 12-11-26.
//  Copyright (c) 2012年 LongMaster Inc. All rights reserved.
//

/*
 * 类名：相机类。[根据UIImagePickerController定制]
 * 功能：利用apple设备进行相机拍照。可连续拍摄多张。【拍摄多张时，以后可以增加拍照成功的界面提示，目前没有考虑。】
 * 注意：使用时只需实现CameraControllerDelegate即可，不用实现父类的delegate。
 * 修改人员：无。
 * 修改日期：无。
 
 * 使用示例：
   -(void)callCamera{
        CameraController *camera = [[CameraController alloc] init];
        camera.cameraDelegate = self;
        [self presentModalViewController:camera animated:YES];
        [camera release];
    }
 */

#import <UIKit/UIKit.h>
#import "BaseUIImagePickerController.h"

typedef enum {
    enumFlashTypeAuto = 0,      //自动
    enumFlashTypeOpen = 1,      //打开
    enumFlashTypeClose = 2,     //关闭
} KFlashType;

@protocol CameraControllerDelegate;

@interface CameraController:BaseUIImagePickerController<UIImagePickerControllerDelegate>{
    UIButton *_swithButton;
    UIImageView *_takeImageView;
    UIButton *_flashButtonAuto;//闪关灯按钮 自动
    UIButton *_flashButtonOpen;//闪关灯按钮 打开
    UIButton *_flashButtonClose;//闪关灯按钮 关闭
    KFlashType _flashType; //闪关灯按钮状态
    UIImageView *_flashImage;//闪光灯按钮显示
    UIView *_topBackImg;
    
}
@property(nonatomic,assign)id<CameraControllerDelegate> cameraDelegate;
@property(nonatomic,assign) BOOL hiddenPhotoBtn;
@property(nonatomic,assign) BOOL useFrontCamera;
@end


@protocol CameraControllerDelegate<NSObject>

@optional
//图片回调。
-(void)cameraController:(CameraController *)camera didFinishImage:(UIImage *)image;

//取消回调。
-(void)cameraControllerDidCancel:(CameraController *)camera;

//点击相册按钮回调。
-(void)cameraControllerDidPhoto:(CameraController *)camera;

//异常错误。
-(void)cameraController:(CameraController *)camera onError:(NSString *)error;

@end
