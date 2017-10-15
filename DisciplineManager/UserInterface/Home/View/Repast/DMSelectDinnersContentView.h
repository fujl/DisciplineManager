//
//  DMSelectDinnersContentView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMSelectDinnerItemView.h"

@interface DMSelectDinnersContentView : UIView
@property (nonatomic, strong) NSMutableArray<DMSelectDinnerItemView *> *disheViewList;
@property (nonatomic, strong) NSMutableArray<DMDishModel *> *dishes;

@end
