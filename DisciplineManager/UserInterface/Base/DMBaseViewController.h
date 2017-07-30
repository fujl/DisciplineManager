//
//  DMBaseViewController.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMBaseViewController : UIViewController

// 判断是否有网络
- (BOOL)hasNetwork;

- (void)addNavRightItem:(SEL)selector andTitle:(NSString *)title;
- (void)addNavLeftItem:(SEL)selector andTitle:(NSString *)title;
- (void)addNavBackItem:(SEL)selector;

- (void)addNavBackItemAndLetfItems:(SEL)selector andTitle:(NSArray *)titleArr;
- (void)addNavBackItemAndLetfItems:(SEL)selector andImageArr:(NSArray *)imageArr;

@end
