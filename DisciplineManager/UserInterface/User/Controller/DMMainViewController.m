//
//  DMMainViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMainViewController.h"
#import "DMNavigationController.h"
#import "DMHomeViewController.h"
#import "DMMoreViewController.h"

@interface DMMainViewController ()

@end

@implementation DMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xebebeb] size:CGSizeMake(SCREEN_WIDTH, 0.5f)]];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    //tabBarItem 字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGB:0xd9534f]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGB:0x858585]} forState:UIControlStateNormal];
    
    UINavigationController *homeNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMHomeViewController alloc] init]];
    
    homeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"home", @"政") image:[[UIImage imageNamed:@"ic_action_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *mineNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMMoreViewController alloc] init]];
    
    mineNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"mine", @"我的") image:[[UIImage imageNamed:@"ic_action_my_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_my_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.viewControllers = @[homeNavigationController, mineNavigationController];
}

@end
