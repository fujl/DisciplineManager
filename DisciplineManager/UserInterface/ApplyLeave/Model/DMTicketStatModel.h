//
//  DMTicketStatModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTicketStatModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger ticketType;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
