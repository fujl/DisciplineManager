//
//  DMLoginViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLoginViewController.h"
#import "DMMainViewController.h"
#import "DMNavigationController.h"
#import "DMUserManager.h"

#define kHeadHeight     (SCREEN_WIDTH*0.618)

@interface DMLoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *bgInfoView;
@property (nonatomic, strong) UITextField *userNameView;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UITextField *pwdView;


@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *copyrightLabel;
@end

@implementation DMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray<__kindof UIView*> *childViews  = [[NSMutableArray alloc] init];
    [self.headView addSubview:self.titleLabel];
    [self.headView addSubview:self.iconView];
    [self.headView addSubview:self.nameLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView).offset(20);
        make.centerX.equalTo(self.headView);
    }];
    
    UIImage *launcher = [UIImage imageNamed:@"ic_launcher"];
    self.iconView.image = launcher;
    CGFloat sep = IPHONE5 ? 80 : 50;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headView);
        make.width.equalTo(@(launcher.size.width-sep));
        make.height.equalTo(@(launcher.size.height-sep));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.headView);
    }];
    
    [childViews addObject:self.headView];
    
    [self.bgInfoView addSubview:self.userNameView];
    [self.bgInfoView addSubview:self.firstLine];
    [self.bgInfoView addSubview:self.pwdView];
    
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgInfoView);
        make.left.equalTo(self.bgInfoView).offset(10);
        make.right.equalTo(self.bgInfoView).offset(-10);
        make.height.equalTo(@(44));
    }];
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgInfoView);
        make.top.equalTo(self.userNameView.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgInfoView).offset(10);
        make.right.equalTo(self.bgInfoView).offset(-10);
        make.top.equalTo(self.firstLine.mas_bottom);
        make.height.equalTo(@(44));
    }];
    
    [childViews addObject:self.bgInfoView];
    [childViews addObject:self.loginBtn];
    
    [self.bottomView addSubview:self.copyrightLabel];
    [self.bottomView addSubview:self.companyLabel];
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-20);
    }];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.bottom.equalTo(self.copyrightLabel).offset(-20);
    }];
    
    [childViews addObject:self.bottomView];
    [self setChildViews:childViews];
}

#pragma mark - getters and setters
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor colorWithRGB:0x337ab7];
        _headView.lcHeight = kHeadHeight;
    }
    return _headView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = NSLocalizedString(@"login_user", @"登录");
    }
    return _titleLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:22];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = NSLocalizedString(@"app_name", @"纪管系统");
    }
    return _nameLabel;
}

- (UIView *)bgInfoView {
    if (!_bgInfoView) {
        _bgInfoView = [[UIView alloc] init];
        _bgInfoView.backgroundColor = [UIColor clearColor];
        _bgInfoView.lcLeftMargin = 35;
        _bgInfoView.lcRightMargin = 35;
        _bgInfoView.lcTopMargin = 20;
        _bgInfoView.lcHeight = 88.5;
        _bgInfoView.layer.masksToBounds = YES;
        _bgInfoView.layer.cornerRadius = 4;
        _bgInfoView.layer.borderColor = [UIColor colorWithRGB:0xEBEBEB].CGColor;
        _bgInfoView.layer.borderWidth = 1.0f;
    }
    return _bgInfoView;
}

- (UITextField *)userNameView {
    if (!_userNameView) {
        _userNameView = [[UITextField alloc] init];
        _userNameView.font = [UIFont systemFontOfSize:16];
        _userNameView.textColor = [UIColor colorWithRGB:0x000000];
        _userNameView.placeholder = NSLocalizedString(@"user_name_tip", @"请输入用户名");
        _userNameView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameView.tag = 101;
        _userNameView.delegate = self;
        [_userNameView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _userNameView;
}

- (UIView *)firstLine {
    if (!_firstLine) {
        _firstLine = [[UIView alloc] init];
        _firstLine.backgroundColor = [UIColor colorWithRGB:0xEBEBEB];
    }
    return _firstLine;
}

- (UITextField *)pwdView {
    if (!_pwdView) {
        _pwdView = [[UITextField alloc] init];
        _pwdView.placeholder = NSLocalizedString(@"password_tip", @"请输入密码");
        _pwdView.keyboardType = UIKeyboardTypeEmailAddress;
        _pwdView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdView.delegate = self;
        _pwdView.font = [UIFont systemFontOfSize:16];
        _pwdView.textColor = [UIColor colorWithRGB:0x000000];
        _pwdView.secureTextEntry = YES;
        [_pwdView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        _loginBtn.clipsToBounds = YES;
        _loginBtn.layer.cornerRadius = 2.5;
        _loginBtn.lcTopMargin = 20; // forgetPwsBackView 存在的时候 13
        _loginBtn.lcLeftMargin = 35;
        _loginBtn.lcRightMargin = 35;
        _loginBtn.lcHeight = 45;
        [_loginBtn setTitle:NSLocalizedString(@"login_user", @"登录") forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(onLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage *imageNormal = [UIImage imageWithColor:[UIColor colorWithRGB:0x64C990] size:CGSizeMake(SCREEN_WIDTH-70, 45)];
        [_loginBtn setBackgroundImage:imageNormal forState:UIControlStateNormal];
        UIImage *imageDisabled = [UIImage imageWithColor:[UIColor colorWithRGB:0xCCCCCC] size:CGSizeMake(SCREEN_WIDTH-70, 45)];
        [_loginBtn setBackgroundImage:imageDisabled forState:UIControlStateDisabled];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.lcTopMargin = 10;
        _bottomView.lcBottomMargin = 0;
        _bottomView.lcHeight = SCREEN_HEIGHT-10-20-45-20-88.5-kHeadHeight;
    }
    return _bottomView;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textAlignment = NSTextAlignmentCenter;
        _companyLabel.font = [UIFont systemFontOfSize:14];
        _companyLabel.textColor = [UIColor blackColor];
        _companyLabel.text = NSLocalizedString(@"company_name", @"兴义市石头科技有限公司");
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

#pragma mark - UIControlEventEditingChanged
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.userNameView.text.length > 0 && self.pwdView.text.length > 0) {
        _loginBtn.enabled = YES;
    } else {
        _loginBtn.enabled = NO;
    }
}

#pragma mark - event method
- (void)onLoginBtnClick {
    [AppWindow endEditing:YES];
    if (self.userNameView.text.length<=0) {
        showToast(NSLocalizedString(@"user_name_tip", @"请输入用户名"));
        return;
    }
    
    if (self.pwdView.text.length<=0) {
        showToast(NSLocalizedString(@"password_tip", @"请输入密码"));
        return;
    }
    DMUserManager *userManager = getManager([DMUserManager class]);
    NSString *pwd = [self.pwdView.text md5];
    showLoadingDialog();
    [userManager login:self.userNameView.text password:pwd callback:^(DMResultCode code, NSString *errMsg) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            [userManager startMainController];
        } else {
            showToast(errMsg);
        }
    }];
}

@end
