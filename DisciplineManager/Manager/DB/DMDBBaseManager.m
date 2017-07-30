//
//  DMDBBaseManager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDBBaseManager.h"

@implementation DMDBBaseManager

- (void)submitDatabaseTask:(id (^)(FMDatabase *db))dbTask andResultListener:(void (^)(id result))resultListener {
    
}

- (void)submitDatabaseTask:(void (^)(FMDatabase *db))dbTask {
    
}

//读取Document目录
- (NSString *)getAppDocumentDirectory {
    NSArray *lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([lpPaths count] > 0) {
        return lpPaths[0];
    } else {
        return nil;
    }
}

@end
