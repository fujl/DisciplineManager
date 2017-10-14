//
//  DMNoticeViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticeViewController.h"
#import "DMNoticePublishController.h"

@interface DMNoticeViewController ()

@end

@implementation DMNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"notice", @"通知公告");
    
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"")];
}

- (void)clickPublish {
    DMNoticePublishController *controller = [[DMNoticePublishController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
