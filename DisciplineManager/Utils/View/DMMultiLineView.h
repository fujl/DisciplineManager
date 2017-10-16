//
//  DMMultiLineView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMMultiLineView : UIView

@property (nonatomic, strong) UILabel *detailLabel;
- (void)hiddenBottomLine:(BOOL)hidden;
- (void)setTitle:(NSString *)title detail:(NSString *)detail;

@end
