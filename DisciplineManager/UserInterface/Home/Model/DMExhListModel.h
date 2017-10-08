//
//  DMExhListModel.h
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMExhListModel : NSObject

@property (nonatomic, copy) NSString *elId;         //"5993AAD067FC46D79D7CBB93232EC25D",
@property (nonatomic, copy) NSString *createDate;   // ": "2017-10-04 12:58:20",
@property (nonatomic, copy) NSString *content;      //": "测试工作展晒提交数据",
@property (nonatomic, copy) NSString *orgCode;      //": "001",
@property (nonatomic, copy) NSString *userId;       //": "b6256756-fc43-4a14-a8aa-89aaafdb9b26",
@property (nonatomic, copy) NSString *userName;     //":"系统管理员",
@property (nonatomic, copy) NSString *face;         //”:”头像地址”
@property (nonatomic, strong) NSArray *imagePaths;   //": ["upload\\images\\2017100413120295.jpg", "upload\\images\\201710041306357864.jpg"],
@property (nonatomic, assign) NSInteger praiseTotal;  //": 0, // 点赞总数
@property (nonatomic, assign) BOOL userIsPraise; //": false, // 当前用户是否点赞
@property (nonatomic, copy) NSString *timeTxt;      //": "1天前"*/

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
