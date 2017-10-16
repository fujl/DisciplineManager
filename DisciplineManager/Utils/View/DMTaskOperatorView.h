//
//  DMTaskOperatorView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMTaskOperator) {
    TaskOperator_Agree                  = 0,                // 同意
    TaskOperator_TransferComment        = 1,                // 转批
    TaskOperator_Rejected               = 2,                // 驳回
    TaskOperator_Finish                 = 3,                // 完成回岗
};

@interface DMTaskOperatorView : UIView

@property (nonatomic, copy) void (^clickTaskOperatorBlock)(DMTaskOperator taskOperator);

- (void)refreshView:(BOOL)showTransferComment;

- (void)refreshFinishHuigangView;

- (void)refreshJsyView;

@end
