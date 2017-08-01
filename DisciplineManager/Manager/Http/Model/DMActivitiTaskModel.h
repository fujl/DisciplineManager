//
//  DMActivitiTaskModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserModel.h"

#define kDefinitionKeyQJSQ_BMLD  @"qjsp_bmld"
#define kDefinitionKeyQJSQ_FGLD  @"qjsp_fgld"

#define kDefinitionKeyBXP   @"bxp_fgld"

#define kDefinitionKeyGCSQ_SJLD     @"gcsq_sjld"        // 上级审批
#define kDefinitionKeyGCSQ_BGSSP    @"gcsq_bgssp"       // 办公室审批
#define kDefinitionKeyGCSQ_JSY      @"gcsq_jsy"         // 驾驶员审批

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
