//
//  BaseUIImagePickerController.h
//  PhonePlus
//
//  Created by lihuan on 12-12-19.
//  Copyright (c) 2012年 LongMaster Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseUIImagePickerController : UIImagePickerController<UINavigationControllerDelegate
>
{
    NSTimeInterval modalViewPresentOrDismissMovingTime;
}
@end
