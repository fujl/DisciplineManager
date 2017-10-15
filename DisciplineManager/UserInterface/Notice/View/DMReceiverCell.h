//
//  DMReceiverCell.h
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMUserBookModel.h"

@interface DMReceiverCell : UITableViewCell

@property (nonatomic, copy) void (^onSelectUserBlock)(DMUserBookModel *user, BOOL selectedUser);
@property (nonatomic, strong) DMUserBookModel *userInfo;
@property (nonatomic, assign) BOOL selectedUser;
@end
