//
//  DMReceiverView.h
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOrgModel.h"
#import "DMUserBookModel.h"

@interface DMReceiverView : UIView

@property (nonatomic, strong) DMOrgModel *orgInfo;
@property (nonatomic, strong) NSMutableDictionary *selectedUserDictionary;

@end
