//
//  DMCmsContentRequster.h
//  DisciplineManager
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMCmsContentRequster : DMHttpRequester
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@end
