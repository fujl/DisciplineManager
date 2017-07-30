//
//  DMNavigationController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNavigationController.h"

@interface DMNavigationController ()

@end

@implementation DMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    if (![viewController isKindOfClass:[DMBaseViewController class]]) {
        NSString *msg = [NSString stringWithFormat:@"%@\n\n未继承BaseViewController", NSStringFromClass([viewController class])];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"hint", @"提示") message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"sure", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            exit(0);
        }]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

@end
