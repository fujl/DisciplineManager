//
//  DMNoticePublishController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticePublishController.h"

@interface DMNoticePublishController ()

@end

@implementation DMNoticePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"publish_notice", @"发布通知");
    
    [self addNavRightItem:@selector(clickCommit) andTitle:NSLocalizedString(@"Commit", @"")];
}

- (void)clickCommit {
    
}

@end
