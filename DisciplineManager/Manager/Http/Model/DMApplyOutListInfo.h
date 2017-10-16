//
//  DMApplyOutListInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMFormBaseInfo.h"

@interface DMApplyOutListInfo : DMFormBaseInfo

@property (nonatomic, strong) NSString *province;//": "贵州省", // 地址-省
@property (nonatomic, strong) NSString *city;//": "黔西南布依族苗族自治州", // 地址-市
@property (nonatomic, strong) NSString *county;//": "兴义市", // 地址-县
@property (nonatomic, strong) NSString *address;//": "荣御天下", // 详细地址
@property (nonatomic, assign) NSInteger isNeedCar;//": 是否需要公车 1 需要 0 不需要, 其他为错误,
@property (nonatomic, strong) NSString *driverId;//": '司机ID, 当isNeedCar=1时有效',
@property (nonatomic, strong) NSString *driverName;//": '司机姓名, 当isNeedCar=1时有效',
@property (nonatomic, strong) NSString *officialCar;//": '车辆信息对象, 当isNeedCar=1时有效'


@end
