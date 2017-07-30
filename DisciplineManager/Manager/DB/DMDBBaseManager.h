//
//  DMDBBaseManager.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseManager.h"
#import "FMDB.h"

@interface DMDBBaseManager : DMBaseManager

/**
 *  提交任务到数据库执行
 *
 *  @param dbTask         在数据库线程执行的任务, 返回执行结果
 *  @param resultListener 数据库任务执行完成后，主线程的结果回调函数，传入参数就是数据库任务返回的结果。
 */
- (void)submitDatabaseTask:(id (^)(FMDatabase *db))dbTask andResultListener:(void (^)(id result))resultListener;

/**
 *  提交任务到数据库执行
 *
 *  @param dbTask 数据库执行的任务
 */
- (void)submitDatabaseTask:(void (^)(FMDatabase *db))dbTask;

- (NSString *)getAppDocumentDirectory;

@end
