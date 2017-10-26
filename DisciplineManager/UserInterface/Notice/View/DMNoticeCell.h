//
//  DMNoticeCell.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMNoticeInfo.h"

@interface DMNoticeCell : UITableViewCell

@property (nonatomic, strong) DMNoticeInfo *noticeInfo;
- (void)hiddenBottomLine:(BOOL)hidden;

@end
