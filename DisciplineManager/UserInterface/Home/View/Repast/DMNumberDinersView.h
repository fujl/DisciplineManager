//
//  DMNumberDinersView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMRepastTimeModel.h"
#import "DMStatTotalModel.h"

@interface DMNumberDinersView : UIView

- (void)setNumberDinersInfo:(DMRepastTimeModel *)timeModel statTotal:(DMStatTotalModel *)statTotal;

@end
