//
//  DMApplyLeaveListInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFormBaseInfo.h"

@interface DMApplyLeaveListInfo : DMFormBaseInfo
@property (nonatomic, assign) DMLeaveType type;         // 请休假类别 0 请假, 1 休假
@property (nonatomic, assign) DMDateType startTimeType; // 开始时间类别, 0 上午, 1 下午, 用于计算
@property (nonatomic, assign) DMDateType endTimeType;   // 结束时间类别, 0 上午, 1 下午, 用于计算
@property (nonatomic, strong) NSString *holiday;        // 可选, 节假日, 此字段根据开始时间,与结束时间 调用接口匹配计算生成, 如果所选开始结束日期没有节假日, 则传递””空字符串就行 逗号分隔
@property (nonatomic, assign) CGFloat days;           // 请假天数, 根据开始日期, 结束日期, 日期类别计算, 如果小于等于0 不允许提交
@property (nonatomic, strong) NSString *ticket;         // 当type=1时必须, 所选电子票ID, 多条数据用逗号分隔
@end
