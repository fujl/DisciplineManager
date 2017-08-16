//
//  DMWebViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMWebViewController.h"
#import "DMCMSDetailRequester.h"

@interface DMWebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DMCmsContentModel *detailModel;
@end

@implementation DMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.cmsModel.title;
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadCMSDetail];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
//        [_webView setOpaque:NO];
//        _webView.scalesPageToFit = YES;
//        _webView.userInteractionEnabled = NO;
        _webView.backgroundColor = [UIColor clearColor];
//        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}

- (void)loadCMSDetail {
    showLoadingDialog();
    DMCMSDetailRequester *requester = [[DMCMSDetailRequester alloc] init];
    requester.ccId = self.cmsModel.ccId;
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            self.detailModel = data;
            [self.webView loadHTMLString:self.detailModel.txt baseURL:nil];
        } else {
            showToast(@"拉取文章失败");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
