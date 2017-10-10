//
//  DMVoteOptionView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMVoteOptionInfo.h"

@interface DMVoteOptionView : UIView

@property (nonatomic, readonly) UIButton * _Nonnull optionBtn;

/**
 点击项事件
 */
@property (nullable, nonatomic, copy) void (^clickOptionBlock)(DMVoteOptionView * _Nonnull optionView);

- (instancetype _Nonnull )initWithOptionInfo:(DMVoteOptionInfo *_Nonnull)info isEnd:(BOOL)isEnd;

@end
