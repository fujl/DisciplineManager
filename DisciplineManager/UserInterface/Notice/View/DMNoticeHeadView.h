//
//  DMNoticeHeadView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMNoticeHeadView : UIView

@property (nonatomic, assign) NoticeType type;
@property (nonatomic, copy) void (^onSelectNoticeType)();
@end
