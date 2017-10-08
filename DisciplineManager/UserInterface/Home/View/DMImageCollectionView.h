//
//  DMImageCollectionView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEM_WIDTH 80
#define ITEM_HEIGHT 80

#define ITEM_INTERVAL 5

@interface DMImageCollectionView : UIView

@property (nonatomic, strong) NSMutableArray *imageStringList;

@end
