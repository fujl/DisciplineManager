//
//  DMEntrySelectView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMEntrySelectView : UIView
@property (nonatomic, strong) NSString *value;
@property (nonatomic, copy) void (^clickEntryBlock)(NSString *value);

- (void)setPlaceholder:(NSString *)placeholder;
@end
