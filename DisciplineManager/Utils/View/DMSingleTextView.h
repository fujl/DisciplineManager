//
//  DMSingleTextView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/17.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSingleTextView : UIView
- (void)setPlaceholder:(NSString *)placeholder;
- (void)setKeyboardType:(UIKeyboardType)keyboardType;
- (void)setSecureTextEntry:(BOOL)secureTextEntry;
- (NSString *)getSingleText;
@end
