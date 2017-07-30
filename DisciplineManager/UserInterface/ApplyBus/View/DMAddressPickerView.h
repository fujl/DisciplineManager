//
//  DMAddressPicker.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMAddressPickerView : UIView

@property(nonatomic, strong) void (^onCompleteClick)(DMAddressInfo *provinceInfo, DMAddressInfo *cityInfo, DMAddressInfo *areaInfo);
// 显示
- (void)show;

// 隐藏
- (void)dismiss;

- (void)refreshData;

- (void)selected:(NSInteger)provinceId city:(NSInteger)cityId area:(NSInteger)areaId;

@end
