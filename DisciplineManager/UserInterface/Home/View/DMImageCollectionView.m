//
//  DMImageCollectionView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMImageCollectionView.h"
#import "DMImageCollectionCell.h"
#import "MSSBrowseNetworkViewController.h"

@interface DMImageCollectionView ()
@end

@implementation DMImageCollectionView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setImageStringList:(NSMutableArray *)imageStringList {
    _imageStringList = imageStringList;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    CGFloat x = ITEM_INTERVAL;
    CGFloat y = ITEM_INTERVAL;
    NSInteger i = 0;
    for (NSString *path in _imageStringList) {
        NSInteger remainder = i%3;
        NSInteger quotient = i/3;
        x = remainder*ITEM_WIDTH+(remainder+1)*ITEM_INTERVAL;
        y = quotient*ITEM_WIDTH+(quotient+1)*ITEM_INTERVAL;
        DMImageCollectionCell *cell = [[DMImageCollectionCell alloc] initWithFrame:CGRectMake(x, y, ITEM_WIDTH, ITEM_HEIGHT)];
        cell.fileName = path;
        cell.index = i;
        __weak typeof(self) weakSelf = self;
        cell.clickImageAtIndex = ^(NSInteger index, NSString *fileName) {
            [weakSelf clickImage:index fileName:fileName];
        };
        i++;
        [self addSubview:cell];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger count = _imageStringList.count;
        NSInteger remainder = i%3;
        NSInteger quotient = count/3+(remainder==0?0:1);
        make.height.equalTo(@(quotient*ITEM_HEIGHT+(quotient+1)*ITEM_INTERVAL));
    }];
}

- (void)clickImage:(NSInteger)index fileName:(NSString *)fileName {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (NSString *path in self.imageStringList) {
        MSSBrowseModel *model = [[MSSBrowseModel alloc] init];
        model.bigImageUrl = [NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, path];
        [imageArray addObject:model];
    }
    for (int i = 0; i < imageArray.count; i++) {
        MSSBrowseModel *model = [imageArray objectAtIndex:i];
        if ([model.bigImageUrl isEqualToString:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, fileName]]) {
            MSSBrowseNetworkViewController *controller = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:imageArray currentIndex:i];
            [controller showBrowseViewController];
            break;
        }
    }
}

@end
