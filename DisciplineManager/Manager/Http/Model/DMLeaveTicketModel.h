//
//  DMLeaveTicketModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/22.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMLeaveTicketModel : NSObject

@property (nonatomic, strong) NSString *ltId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *expiryDate;
@property (nonatomic, assign) CGFloat days;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL sfgq;

@property (nonatomic, assign) BOOL selected;// 是否选择

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
