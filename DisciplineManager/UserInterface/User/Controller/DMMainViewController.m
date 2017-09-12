//
//  DMMainViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMainViewController.h"
#import "DMNavigationController.h"
#import "DMNewsViewController.h"
#import "DMAddressBookViewController.h"
#import "DMHomeViewController.h"
#import "DMVoteViewController.h"
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
    
    UINavigationController *newsNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMNewsViewController alloc] init]];
    
    newsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"news", @"简讯") image:[[UIImage imageNamed:@"ic_action_news_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_news_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *mobileNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMAddressBookViewController alloc] init]];
    
    mobileNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"AddressList", @"通讯") image:[[UIImage imageNamed:@"ic_action_mobile_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_mobile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *homeNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMHomeViewController alloc] init]];
    
    homeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"home", @"政") image:[[UIImage imageNamed:@"ic_action_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *voteNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMVoteViewController alloc] init]];
    
    voteNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"vote", @"投票") image:[[UIImage imageNamed:@"ic_action_vote_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_vote_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *mineNavigationController = [[DMNavigationController alloc] initWithRootViewController:[[DMMoreViewController alloc] init]];
    
    mineNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"mine", @"我的") image:[[UIImage imageNamed:@"ic_action_my_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_action_my_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.viewControllers = @[newsNavigationController, mobileNavigationController, homeNavigationController, voteNavigationController, mineNavigationController];
    [self setSelectedIndex:2];
}

@end
