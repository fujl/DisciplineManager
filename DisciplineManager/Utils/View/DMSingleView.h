//
//  DMSingleView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSingleView : UIView
@property (nonatomic, strong) UILabel *detailLabel;
- (void)hiddenBottomLine:(BOOL)hidden;
- (void)setTitle:(NSString *)title detail:(NSString *)detail;
- (void)refreshSize:(CGSize)size;
@end
