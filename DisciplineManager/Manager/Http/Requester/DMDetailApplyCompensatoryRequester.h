//
//  DMDetailApplyCompensatoryRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"
#import "DMApplyCompensatoryListInfo.h"

@interface DMDetailApplyCompensatoryRequester : DMHttpRequester
@property (nonatomic, strong) NSString *acId;
@end
