//
//  DMMultiLineTextView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/17.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMMultiLineTextView : UIView
- (void)setPlaceholder:(NSString *)placeholder;
- (NSString *)getMultiLineText;
- (void)setMaxMultiLineTextLength:(NSInteger)maxMultiLineTextLength;
@end
