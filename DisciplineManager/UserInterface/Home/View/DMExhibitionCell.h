//
//  DMExhibitionCell.h
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMExhListModel.h"

typedef void(^ChangeHeightBlock)();

@interface DMExhibitionCell : UITableViewCell
@property (nonatomic, copy) ChangeHeightBlock changeHeightBlock;
@property (nonatomic, strong) DMExhListModel *info;

@end
