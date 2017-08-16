//
//  DMDBCommonManager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

/**
 * 和用户无关数据存储
 */
#import "DMDBCommonManager.h"

// 数据库版本  每次修改一次，该值加一
static const int commonDBVersion = 0;

#define kCommonDBPath @"dm_common_db.sqlite"

@interface DMDBCommonManager ()

@property(nonatomic, strong) FMDatabaseQueue *queue;
@property(nonatomic, strong) dispatch_queue_t taskQueue;

@end

@implementation DMDBCommonManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskQueue = dispatch_queue_create("common_database_thread", nil);
        [self resetDatabase];
    }
    return self;
}

- (void)resetDatabase {
    if (_queue) {
        [_queue close];
    }
    
//    NSString *path = [[self getAppDocumentDirectory] stringByAppendingPathComponent:kCommonDBPath];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dm_common_db" ofType:@"sqlite"];
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self submitDatabaseTask:(id) ^(FMDatabase *db) {
        if ([db tableExists:@"version_info"]) {
            // 表存在，升级
            int oldVersion = [db intForQuery:@"select version from version_info"];
            if (oldVersion != commonDBVersion) {
                [self onUpgrade:db newVersion:commonDBVersion oldVersion:oldVersion];
                [db executeUpdate:@"update version_info set version = ?", @(commonDBVersion)];
            }
        } else {
            // 表不存在 创建数据库表
            [self onCreate:db];
            [db executeUpdate:@"create table version_info(version integer)"];
            [db executeUpdate:@"insert into version_info(version) values(?)", @(commonDBVersion)];
        }
    }];
    
}

- (void)submitDatabaseTask:(id (^)(FMDatabase *db))dbTask andResultListener:(void (^)(id))resultListener {
    NSAssert([NSThread isMainThread], @"本方法只能在UI线程中被调用");
    dispatch_async(_taskQueue, ^{
        [_queue inDatabase:^(FMDatabase *db) {
            id data = dbTask(db);
            if (resultListener) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultListener(data);
                });
            }
        }];
    });
}

- (void)submitDatabaseTask:(void (^)(FMDatabase *db))dbTask {
    [self submitDatabaseTask:(id) ^(FMDatabase *db) {
        dbTask(db);
        return nil;
    } andResultListener:nil];
}


/**
 *  数据库创建
 *
 *  @param db 数据库操作API
 */
- (void)onCreate:(FMDatabase *)db {
    [self createAddressInfo:db];
}

/**
 *  数据库升级  用于增加字段，新增表等操作
 *
 *  @param db         数据库API
 *  @param newVersion 新的版本
 *  @param oldVersion 当前数据的版本，旧的版本
 */
- (void)onUpgrade:(FMDatabase *)db newVersion:(int)newVersion oldVersion:(int)oldVersion {
    
}

#pragma mark - Create Table
- (void)createAddressInfo:(FMDatabase *)db {
    [db executeUpdate:@"create table address_info(id integer primary key autoincrement, address_type integer, address_id integer, address_pid integer, name text)"];
}
@end
