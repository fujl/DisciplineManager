//
//  DMSignTimeView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMRepastTimeModel.h"

@interface DMSignTimeView : UIView

@property (nonatomic, strong) DMRepastTimeModel * _Nonnull repastTimeModel;
@property (nonatomic, readonly) BOOL canSign;

/**
 点击项事件
 */
@property (nullable, nonatomic, copy) void (^signObsoleteEvent)();

- (void)signedVote;

- (void)closeTimer;

@end
