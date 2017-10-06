//
//  DMExhibitionViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhibitionViewController.h"
#import "DMExhibitionPublishController.h"

@interface DMExhibitionViewController ()

@end

@implementation DMExhibitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"exhibition", @"");
    [self addNavRightItem:@selector(clickPublish) andTitle:NSLocalizedString(@"Publish", @"")];
}

- (void)clickPublish {
    DMExhibitionPublishController *controller = [[DMExhibitionPublishController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
