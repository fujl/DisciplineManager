//
//  DMSuperviseViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviseViewController.h"
#import "DMSuperviseFillinController.h"

@interface DMSuperviseViewController ()

@end

@implementation DMSuperviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"temporary_task", @"督办任务");
    [self addNavRightItem:@selector(clickApply) andTitle:NSLocalizedString(@"Apply",@"申请")];
}

- (void)clickApply {
    DMSuperviseFillinController *controller = [[DMSuperviseFillinController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
