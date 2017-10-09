//
//  DMVoteDetailController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteDetailController.h"
#import "DMDetailVoteRequester.h"

@interface DMVoteDetailController ()

@end

@implementation DMVoteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投票详情";
    [self getDetailInfo:nil];
}

#pragma mark - get data
- (void)getDetailInfo:(void (^)(DMResultCode code, id data))callback {
    DMDetailVoteRequester *requester = [[DMDetailVoteRequester alloc] init];
    requester.vlId = self.vlId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            callback(code, data);
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

@end
