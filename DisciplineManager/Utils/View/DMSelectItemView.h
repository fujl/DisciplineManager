//
//  DMSelectItemView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSelectItemView : UIView

@property (nonatomic, copy) void (^clickEntryBlock)(NSString *value);

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;

- (void)hiddenArrow;

@end
