//
//  DMAddressInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AddressType) {
    AddressTypeCity = 0,            // 市
    AddressTypeProvince,            // 省
    AddressTypeArea,                // 区
};

@interface DMAddressInfo : NSObject

@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, assign) NSInteger addressPid;
@property (nonatomic, assign) AddressType type;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithCopy:(DMAddressInfo *)copy;
@end
