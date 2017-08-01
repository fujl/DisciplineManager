//
//  DMPickerView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPickerView : UIView

// NSDictionary key有 name、value 一一对应
- (instancetype)initWithArr:(NSArray <__kindof NSDictionary *> *)dataArr;

- (instancetype)initWithEnglishTitleArr:(NSArray <__kindof NSString *> *)titleArr;

- (void)showPickerView;

- (void)hiddenPickerView;

@property(nonatomic, strong) void (^onCompleteClick)(NSDictionary *dic);

- (void)selectID:(NSString *)Id;

@end
