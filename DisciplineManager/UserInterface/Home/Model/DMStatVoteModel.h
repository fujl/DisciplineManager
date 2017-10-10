//
//  DMStatVoteModel.h
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RepastType) {
    /**
     * 早餐
     */
    RepastTypeBreakfast,
    /**
     * 午餐
     */
    RepastTypeLunch,
};

@interface DMStatVoteModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *dishesName;
@property (nonatomic, assign) RepastType type;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
