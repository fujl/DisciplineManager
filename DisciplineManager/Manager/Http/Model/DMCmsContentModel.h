//
//  HMCmsContentModel.h
//  DisciplineManager
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/*"id": 1,
 "createTime": "2017-08-08 22:58:08",
 "channel": { // 所属栏目对象
 "id": 16,
 "optLock": 0,
 "createTime": "2017-07-17 22:03:55",
 "title": "最新动态",
 "parentId": 0,
 "isDisplay": 1,
 "siteId": 0,
 "accessPath": "zxdt",
 "priority": 0,
 "imgPath": null,
 "isLeaf": false,
 "name": null,
 "icon": null,
 "pid": null,
 "isParent": false,
 "children": []
 },
 "title": "test",
 "shortTitle": "",
 "titleColor": "",
 "isBold": 0,
 "tag": "",
 "summary": "",
 "authorId": "b6256756-fc43-4a14-a8aa-89aaafdb9b26",
 "author": "系统管理员",
 "source": "",
 "soruceUrl": null,
 "type": 0,
 "templateId": null,
 "recommend": 0,
 "draft": 0,
 "templateMobileId": null,
 "txt": "<p>fdsafdsa</p>",
 "imgPath": "/framework/upload/images/20170808/1502204283387059333.jpg"
*/
@interface DMCmsContentModel : NSObject

@property (nonatomic, assign) NSInteger ccId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *shortTitle;
@property (nonatomic, strong) NSString *txt;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, assign) NSInteger type;// 0普通, 1图文, 2焦点, 3头条

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
