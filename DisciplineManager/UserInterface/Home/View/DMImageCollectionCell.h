//
//  DMImageCollectionCell.h
//  DisciplineManager
//
//  Created by apple on 2017/10/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMImageCollectionCell : UIView

@property(nonatomic, copy) NSString * _Nonnull fileName;
@property(nonatomic, assign) NSInteger index;

/**
 点击项事件
 */
@property (nullable, nonatomic, copy) void (^clickImageAtIndex)(NSInteger index, NSString * _Nonnull fileName);

@end
