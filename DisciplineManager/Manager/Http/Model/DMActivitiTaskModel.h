//
//  DMActivitiTaskModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserModel.h"

#define kDefinitionKeyWCSQ_SJLD  @"wcsq_sjld"
#define kDefinitionKeyWCSQ_WCHG  @"wcsq_wchg"

#define kDefinitionKeyQJSQ_BMLD  @"qjsp_bmld"
#define kDefinitionKeyQJSQ_FGLD  @"qjsp_fgld"
#define kDefinitionKeyQJSQ_TJFGLD @"qjsq_tjfgld"

#define kDefinitionKeyBXP   @"bxp_fgld"

#define kDefinitionKeyGCSQ_SJLD     @"gcsq_sjld"        // 上级审批
#define kDefinitionKeyGCSQ_BGSSP    @"gcsq_bgssp"       // 办公室审批
#define kDefinitionKeyGCSQ_JSY      @"gcsq_jsy"         // 驾驶员审批

/*
	当definitionKey = bxp_bmld、 bxp_fgld、bxp_rsk时审核表单样式, 可以共用一个表单, 根据definitionKey 判断显示不同的表单界面分管领导审批时definitionKey =bxp_fgld,需要传递参数 emp = HR
    当人事科审批时definitionKey =bxp_rsk，点击同意按钮时，必须传递 补休（半天）天数、补休（一天）天数，以及有效期，需判断天数必须大于等于0， 有效期时间只能选择当前时间之后
*/
#define kDefinitionKeyBXP_BMLD      @"bxp_bmld"
#define kDefinitionKeyBXP_FGLD      @"bxp_fgld"
#define kDefinitionKeyBXP_RSK       @"bxp_rsk"

@interface DMActivitiTaskModel : NSObject
@property (nonatomic, strong) NSString *atId;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *formKey;
@property (nonatomic, strong) NSString *definitionKey;
@property (nonatomic, strong) DMUserModel *user;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
