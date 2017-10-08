//
//  DMExhListModel.m
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhListModel.h"

@implementation DMExhListModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.elId = parseStringFromObject([dict objectForKey:@"id"]);//": "5993AAD067FC46D79D7CBB93232EC25D",
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);//: "2017-10-04 12:58:20",
        self.content = parseStringFromObject([dict objectForKey:@"content"]);//: "测试工作展晒提交数据",
        self.orgCode = parseStringFromObject([dict objectForKey:@"orgCode"]);//: "001",
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);//: "b6256756-fc43-4a14-a8aa-89aaafdb9b26",
        self.userName = parseStringFromObject([dict objectForKey:@"userName"]);//:"系统管理员",
        self.face = parseStringFromObject([dict objectForKey:@"face"]);//:”头像地址”
        self.imagePaths = parseArrayFromObject([dict objectForKey:@"imagePaths"]);//: ["upload\\images\\2017100413120295.jpg", "upload\\images\\201710041306357864.jpg"],
        self.praiseTotal = [parseNumberFromObject([dict objectForKey:@"praiseTotal"]) integerValue]; // 点赞总数
        self.praiseTotal = [parseNumberFromObject([dict objectForKey:@"userIsPraise"]) integerValue]; // 当前用户是否点赞
        self.timeTxt = parseStringFromObject([dict objectForKey:@"timeTxt"]); //: "1天前"
    }
    return self;
}

@end
