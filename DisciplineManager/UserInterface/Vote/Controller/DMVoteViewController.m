//
//  DMVoteViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/9/12.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteViewController.h"

@implementation DMVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"vote",@"投票");
    
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"发布")];
    
    
}

- (void)clickPublish {
    
}

@end
