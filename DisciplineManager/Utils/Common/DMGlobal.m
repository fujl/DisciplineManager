//
//  DMGlobal.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMGlobal.h"

// 全局toast 避免多个toast出现在界面上
static MBProgressHUD *lastToast;

// 尽量控制toast字数，文字太多用户阅读不过来，使用弹框显示
void showToastWithDelay(NSString *msg, NSTimeInterval delay) {
    if (msg.length > 15) {
        // 字数太长
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"sure", @"确定") style:UIAlertActionStyleDefault handler:nil]];
        [AppRootViewController presentViewController:alertView animated:YES completion:nil];
    } else {
        if (lastToast) {
            // 去掉上一个toast
            [lastToast hideAnimated:NO];
        }
        // 少量信息，使用toast显示
        MBProgressHUD *toast = [MBProgressHUD showHUDAddedTo:AppWindow animated:YES];
        toast.mode = MBProgressHUDModeText;
        toast.contentColor = [UIColor whiteColor];
        toast.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        toast.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        toast.label.text = msg;
        toast.completionBlock = ^() {
            lastToast = nil;
        };
        [toast setUserInteractionEnabled:NO];
        [toast hideAnimated:YES afterDelay:delay];
        lastToast = toast;
    }
}

void showToast(NSString *msg) {
    showToastWithDelay(msg, 1.5f);
}

MBProgressHUD *showLoadingDialog() {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:AppWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    return hud;
}

void dismissLoadingDialog() {
    [MBProgressHUD hideHUDForView:AppWindow animated:YES];
}

#pragma mark - parse Object
NSString *parseStringFromObject(id obj) {
    if ([obj isEqual:[NSNull null]]) {
        return @"";
    } else {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        } else {
            return [NSString stringWithFormat:@"%@", obj];
        }
    }
}

NSNumber *parseNumberFromObject(id obj) {
    if ([obj isEqual:[NSNull null]]) {
        return @(0);
    } else {
        if ([obj isKindOfClass:[NSNumber class]]) {
            return obj;
        } else {
            if ([DMConfig mainConfig].serverName == ServerNameTest) {
                assert("数据类型不对");
            }
            return @(0);
        }
    }
}
