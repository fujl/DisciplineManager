//
//  DMHomeHeadView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/3.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "DMMainItemView.h"

@interface DMHomeHeadView : UIView
/**
 点击项事件
 */
@property (nullable, nonatomic, copy) void (^clickItemEvent)(NSInteger tag);

/**
 点击项事件
 */
@property (nullable, nonatomic, copy) void (^didSelectItemAtIndex)(NSInteger index);

@property (nonatomic, strong) SDCycleScrollView * _Nullable logoView;
@property (nonatomic, strong) DMMainItemView * _Nullable todoView;

@property (nonatomic, assign) CGFloat height;

- (void)setImageURLStringsGroup:(NSArray * _Nonnull )imageURLStringsGroup;

@end
