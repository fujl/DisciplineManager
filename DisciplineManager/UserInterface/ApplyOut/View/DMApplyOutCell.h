//
//  DMApplyOutCell.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMApplyOutListInfo.h"

@interface DMApplyOutCell : UITableViewCell
@property (nonatomic, strong) DMFormBaseInfo *info;
+ (CGFloat)getFormHeight:(DMFormBaseInfo *)info;
@end
