//
//  DMAddressManager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAddressManager.h"
#import "DMDBCommonManager.h"

@interface DMAddressManager ()
@property (nonatomic, strong) dispatch_queue_t taskQueue;
@property (nonatomic, strong) NSMutableDictionary *addressQueueDic;// 数据入库队列
@end

@implementation DMAddressManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskQueue = dispatch_queue_create("address_cope_thread", NULL);
        _addressQueueDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 *
 * 得到地址信息
 *
 */
- (void)getAllAddress:(void (^)(NSMutableArray<DMAddressInfo *> *addressList))callback {
    [self getAddressInfoList:0 callback:^(NSMutableArray<DMAddressInfo *> *addressList) {
        if (addressList.count > 0) {
            callback(addressList);
        } else {
            [self deleteAllAddress:^{
                [self initAddressIonfoFromJson:callback];
            }];
        }
    }];
}

/**
 * 从JOSN文件初始化地址信息
 */
- (void)initAddressIonfoFromJson:(void (^)(NSMutableArray<DMAddressInfo *> *addressList))callback {
    dispatch_async(_taskQueue, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:path]) {
            NSData *fileData = [fileManager contentsAtPath:path];
            NSString *fileContent = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            NSArray *citys = [DMJson getJsonObjectFormString:fileContent];
            NSInteger addressId = 1;
            [self analysisAddress:addressId addressPid:0 addressList:citys callback:callback];
        } else {
            NSLog(@"city.json路径出现问题");
        }
    });
}

- (NSInteger)analysisAddress:(NSInteger)addressId
                  addressPid:(NSInteger)addressPid
                 addressList:(NSArray *)addressList
                    callback:(void (^)(NSMutableArray<DMAddressInfo *> *addressList))callback {
    NSInteger addressIdGlobal = addressId;
    NSInteger addressPIdGlobal = addressPid;
    for (NSDictionary *cityDic in addressList) {
        DMAddressInfo *addressInfo = [[DMAddressInfo alloc] init];
        addressInfo.addressId = addressIdGlobal;
        addressInfo.addressPid = addressPIdGlobal;
        addressInfo.name = [cityDic objectForKey:@"name"];
        NSNumber *type = [cityDic objectForKey:@"type"];
        addressInfo.type = type != NULL ? [type integerValue] : AddressTypeArea;
        
        [self.addressQueueDic setObject:addressInfo forKey:[NSNumber numberWithInteger:addressInfo.addressId]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveAddressInfo:addressInfo callback:^(DMAddressInfo *info) {
                [self.addressQueueDic removeObjectForKey:[NSNumber numberWithInteger:info.addressId]];
                if (self.addressQueueDic.count == 0) {
                    NSLog(@"数据插入完成");
                    [self getAddressInfoList:0 callback:callback];
                }
            }];
        });
        
        if (addressInfo.type != AddressTypeArea) {
            NSArray *subCitys = [cityDic objectForKey:@"sub"];
            addressIdGlobal = [self analysisAddress:addressIdGlobal+1 addressPid:addressIdGlobal
                                        addressList:subCitys callback:callback];
        } else {
            addressIdGlobal++;
        }
    }
    return addressIdGlobal;
}

- (void)saveAddressInfo:(DMAddressInfo *)address callback:(void (^)(DMAddressInfo *info))callback {
    DMDBCommonManager *databaseManager = getManager([DMDBCommonManager class]);
    [databaseManager submitDatabaseTask:^id(FMDatabase *db) {
        [db executeUpdate:@"insert into address_info(address_type, address_id, address_pid, name) values(?, ?, ?, ?)",@(address.type), @(address.addressId), @(address.addressPid),address.name];
        return address;
    } andResultListener:^(DMAddressInfo *result) {
        callback(result);
    }];
}

- (void)getAddressInfoList:(NSInteger)addressPid callback:(void (^)(NSMutableArray<DMAddressInfo *> *addressList))callback {
    DMDBCommonManager *databaseManager = getManager([DMDBCommonManager class]);
    [databaseManager submitDatabaseTask:^id(FMDatabase *db) {
        NSMutableArray<DMAddressInfo *> *result = [[NSMutableArray alloc] init];
        FMResultSet *cursor = [db executeQuery:@"select * from address_info where address_pid = ?", @(addressPid)];
        while ([cursor next]) {
            [result addObject:[self createAddressFromFMResultSet:cursor]];
        }
        [cursor close];
        
        return result;
    }  andResultListener:^(NSMutableArray<DMAddressInfo *> *result) {
        callback(result);
    }];
}

- (DMAddressInfo *)createAddressFromFMResultSet:(FMResultSet *)cursor {
    DMAddressInfo *address = [[DMAddressInfo alloc] init];
    address.addressId = [cursor intForColumn:@"address_id"];
    address.addressPid = [cursor intForColumn:@"address_pid"];
    address.type = [cursor intForColumn:@"address_type"];
    address.name = [cursor stringForColumn:@"name"];
    return address;
}

- (void)deleteAllAddress:(void (^)())callback {
    DMDBCommonManager *databaseManager = getManager([DMDBCommonManager class]);
    [databaseManager submitDatabaseTask:^id(FMDatabase *db) {
        [db executeUpdate:@"delete from address_info"];
        return nil;
    } andResultListener:^(id result) {
        callback();
    }];
}

@end
