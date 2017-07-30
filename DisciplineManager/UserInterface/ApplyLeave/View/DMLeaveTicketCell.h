//
//  DMLeaveTicketCell.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLeaveTicketModel.h"

@interface DMLeaveTicketCell : UITableViewCell
@property (nonatomic, strong) DMLeaveTicketModel *leaveTicketModel;
- (void)selectedTicket;
@end
