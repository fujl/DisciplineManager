//
//  DMActivitiTaskModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserModel.h"

#define kDefinitionKeyQJSQ  @"qjsp_bmld"
#define kDefinitionKeyBXP   @"bxp_fgld"
#define kDefinitionKeyGCSQ  @"gcsq_sjld";

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
