//
//  DMOrgView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOrgModel.h"

@interface DMOrgView : UIView

@property (nonatomic, copy) void (^onSelectOrgBlock)(DMOrgModel *orgInfo);

@end
