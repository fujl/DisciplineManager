//
//  DMGlobal.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

void showToast(NSString *msg);

MBProgressHUD *showLoadingDialog();

void dismissLoadingDialog();

#pragma mark - parse Object
NSString *parseStringFromObject(id obj);
NSArray *parseArrayFromObject(id obj);
NSNumber *parseNumberFromObject(id obj);
