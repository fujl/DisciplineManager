//
//  DMMealBarView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMStatVoteModel.h"

@interface DMMealBarView : UIView

@property (nonatomic, strong) NSMutableArray<DMStatVoteModel *> *dishs;
@property (nonatomic, assign) RepastType type;

- (void)strokePath;

@end
