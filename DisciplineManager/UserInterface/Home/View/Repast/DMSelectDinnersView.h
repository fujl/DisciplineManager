//
//  DMSelectDinnersView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMSelectDinnersContentView.h"

@interface DMSelectDinnersView : UIView

@property (nonatomic, strong) DMSelectDinnersContentView *contentView;
@property (nonatomic, strong) NSMutableArray<DMDishModel *> *dishes;
@property (nonatomic, assign) RepastType type;

@end
