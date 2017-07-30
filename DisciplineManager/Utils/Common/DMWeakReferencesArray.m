//
//  LMDWeakReferencesArray.m
//  DisciplineManager
//
//  Created by fujl on 17/6/27.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import "DMWeakReferencesArray.h"

@interface MyWeakRefrence : NSObject

@property(nonatomic, weak) id obj;

@end

@implementation MyWeakRefrence
- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.obj=%@", self.obj];
    [description appendString:@">"];
    return description;
}
@end

@interface DMWeakReferencesArray ()
@property(nonatomic, strong) NSMutableArray *data;
@end

@implementation DMWeakReferencesArray

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

@synthesize count = _count;

- (NSUInteger)count {
    return _data.count;
}

@synthesize allObjects = _allObjects;

- (nonnull NSArray *)allObjects {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (MyWeakRefrence *ref in _data) {
        id obj = ref.obj;
        if (obj) {
            [objects addObject:obj];
        }
    }
    return objects;
}

- (nullable id)objectAtIndex:(NSUInteger)index {
    MyWeakRefrence *ref = _data[index];
    return ref.obj;
}

- (void)addObject:(nullable id)obj {
    MyWeakRefrence *ref = [[MyWeakRefrence alloc] init];
    ref.obj = obj;
    [_data addObject:ref];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_data removeObjectAtIndex:index];
}

- (void)removeObject:(nonnull id)anObject {
    NSArray *copyArray = [NSArray arrayWithArray:_data];
    for (MyWeakRefrence *ref in copyArray) {
        id obj = ref.obj;
        if (anObject == obj) {
            [_data removeObject:ref];
            // 移除一个
            break;
        }
    }
}

- (void)removeAllObjects {
    [_data removeAllObjects];
}

- (void)insertObject:(nullable id)obj atIndex:(NSUInteger)index {
    MyWeakRefrence *ref = [[MyWeakRefrence alloc] init];
    ref.obj = obj;
    [_data insertObject:ref atIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(nullable id)obj {
    MyWeakRefrence *ref = [[MyWeakRefrence alloc] init];
    ref.obj = obj;
    [_data replaceObjectAtIndex:index withObject:ref];
}

- (void)compact {
    NSArray *copyArray = [NSArray arrayWithArray:_data];
    for (MyWeakRefrence *ref in copyArray) {
        id obj = ref.obj;
        if (!obj) {
            [_data removeObject:ref];
        }
    }
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.count=%ld", (unsigned long) self.count];
    [description appendFormat:@", self.data=%@", self.data];
    [description appendFormat:@", self.allObjects=%@", self.allObjects];
    [description appendString:@">"];
    return description;
}

@end
