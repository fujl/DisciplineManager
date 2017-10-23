//
//  DMLeaveTicketViewController.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseViewController.h"
#import "DMLeaveTicketModel.h"

@interface DMLeaveTicketViewController : DMBaseViewController
@property (nonatomic, assign) BOOL isProvideSelect;
@property (nonatomic, copy) void (^selectedLeaveTicketBlock)(NSMutableArray<DMLeaveTicketModel *> *leaveTickets);
@end
