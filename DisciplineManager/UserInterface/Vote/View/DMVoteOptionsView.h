//
//  DMVoteOptionsView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMVoteDetailInfo.h"
#import "DMVoteOptionView.h"

@interface DMVoteOptionsView : UIView

@property (nonatomic, strong) DMVoteDetailInfo *info;

- (instancetype)initWithInfo:(DMVoteDetailInfo *)info;
- (NSString *)getOptionIds;

@end
