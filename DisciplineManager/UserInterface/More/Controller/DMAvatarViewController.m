//
//  DMAvatarViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAvatarViewController.h"

@interface DMAvatarViewController ()

@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation DMAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = NSLocalizedString(@"PersonalAvatar", @"个人头像");
    
    [self.view addSubview:self.avatarView];
    
    UIImage *avatar = [UIImage imageNamed:self.gender == Male ? @"male" : @"female"];
    self.avatarView.image = avatar;
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@(SCREEN_WIDTH-20));
    }];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.userInteractionEnabled = YES;
    }
    return _avatarView;
}
@end
