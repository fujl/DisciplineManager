//
//  DMDetailView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDetailView : UIView
@property (nonatomic, strong) NSString *detail;
- (CGFloat)getHeightFromDetail:(NSString *)detail;
- (CGFloat)getHeightFromPlaceholder:(NSString *)placeholder;

@end
