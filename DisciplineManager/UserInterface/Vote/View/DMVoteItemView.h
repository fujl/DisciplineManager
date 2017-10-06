//
//  DMVoteItemView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMaxItemTextCount   40

@interface DMVoteItemView : UIView

/**
 点击项事件
 */
@property (nullable, nonatomic, copy) void (^clickMinusItem)();

- (void)hiddenMinusItem;

- (void)setPlaceholder:(NSString *_Nonnull)placeholder;

@end
