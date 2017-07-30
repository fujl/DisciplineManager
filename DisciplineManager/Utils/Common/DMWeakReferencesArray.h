//
//  LMDWeakReferencesArray.h
//  DisciplineManager
//
//  Created by fujl on 17/6/27.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMWeakReferencesArray<ObjectType> : NSObject

// 数组的大小， 包括为nil的数据
@property(nonatomic, readonly) NSUInteger count;

// 当前保存的所有非空数据
@property(nonatomic, nonnull, readonly) NSArray<ObjectType> *allObjects;

// 获取数据
- (nullable ObjectType)objectAtIndex:(NSUInteger)index;

// 添加数据
- (void)addObject:(nullable ObjectType)obj;

// 移除数据
- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeObject:(nonnull ObjectType)obj;

//移除所有数据
- (void)removeAllObjects;

// 插入数据
- (void)insertObject:(nullable ObjectType)obj atIndex:(NSUInteger)index;

// 替换数据
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(nullable ObjectType)obj;

// 移除所有的nil数据，紧缩数据。调用本方法后，数组大小，索引会变
- (void)compact;

@end
