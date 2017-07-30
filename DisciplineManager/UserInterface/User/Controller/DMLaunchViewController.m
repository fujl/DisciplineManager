//
//  DMLaunchViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLaunchViewController.h"

@interface DMLaunchViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *copyrightLabel;
@end

@implementation DMLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor appBackground];
    
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.companyLabel];
    [self.view addSubview:self.copyrightLabel];
    UIImage *launcher= [UIImage imageNamed:@"ic_launcher"];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(-50);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(launcher.size.width-30));
        make.height.equalTo(@(launcher.size.height-30));
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoView.mas_bottom).offset(20);
    }];
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
    }];
    
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.image = [UIImage imageNamed:@"ic_launcher"];
    }
    return _logoView;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textAlignment = NSTextAlignmentCenter;
        _companyLabel.font = [UIFont systemFontOfSize:14];
        _companyLabel.textColor = [UIColor blackColor];
        _companyLabel.text = [NSString stringWithFormat:@"技术支持：%@", NSLocalizedString(@"company_name", @"兴义市石头科技有限公司")];
    }
    return _companyLabel;
}

- (UILabel *)copyrightLabel {
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] init];
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.font = [UIFont systemFontOfSize:12];
        _copyrightLabel.textColor = [UIColor colorWithRGB:0xaaaaaa];
        _copyrightLabel.text = NSLocalizedString(@"copyright", @"Copyright© 2016-2017 www.gzstkj.cn");
    }
    return _copyrightLabel;
}

@end
