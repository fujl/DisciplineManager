//
//  DMVoteDetailController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteDetailController.h"
#import "DMDetailVoteRequester.h"
#import "DMVoteHeadView.h"
#import "DMVoteOptionsView.h"

#import "DMVoteDetailInfo.h"

#import "DMSubmitVoteRequester.h"

@interface DMVoteDetailController ()

@property (nonatomic, strong) NSMutableArray *subviewList;

@property (nonatomic, strong) DMVoteHeadView *headView;
@property (nonatomic, strong) DMVoteOptionsView *optionsView;
@property (nonatomic, strong) DMEntryCommitView *commitView;
@property (nonatomic, strong) DMVoteDetailInfo *info;

@end

@implementation DMVoteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投票详情";
    [self refreshView];
}

- (void)refreshView {
    showLoadingDialog();
    [self getDetailInfo:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            self.info = data;
            [self refreshData];
            [self loadSubviews];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)refreshData {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, self.info.user.userInfo.face]];
    [self.headView.faceView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.headView.nameLabel.text = self.info.user.userInfo.name;
    self.headView.timeTxtLabel.text = self.info.timeTxt;
    self.headView.contentLabel.text = self.info.title;
    if (self.info.isEnd) {
        self.headView.stateLabel.text = NSLocalizedString(@"has_ended", @"已结束");
        self.headView.stateLabel.backgroundColor = [UIColor colorWithRGB:0x71b668];
        if (self.info.myTicket > 0) {
//            self.endLabel.text = NSLocalizedString(@"voted_view_results", @"已投票，查看结果");
        } else {
//            self.endLabel.text = NSLocalizedString(@"not_voting_view_results", @"未投票，查看结果");
        }
    } else {
        self.headView.stateLabel.text = NSLocalizedString(@"under_way", @"进行中");
        self.headView.stateLabel.backgroundColor = [UIColor colorWithRGB:0xf2a279];
        if (self.info.myTicket > 0) {
//            self.endLabel.text = NSLocalizedString(@"voted_view_results", @"已投票，查看结果");
        } else {
//            self.endLabel.text = NSLocalizedString(@"immediate_voting", @"立即投票");
        }
    }
    
    self.optionsView.info = self.info;
}

- (void)loadSubviews {
    [self.subviewList removeAllObjects];
    [self.subviewList addObject:self.headView];
    [self.subviewList addObject:self.optionsView];
    if (!self.info.isEnd || self.info.myTicket <= 0) {
        [self.subviewList addObject:self.commitView];
    }
    [self setChildViews:self.subviewList];
}

#pragma mark - get data
- (void)getDetailInfo:(void (^)(DMResultCode code, id data))callback {
    DMDetailVoteRequester *requester = [[DMDetailVoteRequester alloc] init];
    requester.vlId = self.vlId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            callback(code, data);
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMVoteHeadView *)headView {
    if (!_headView) {
        _headView = [[DMVoteHeadView alloc] init];
    }
    return _headView;
}

- (DMVoteOptionsView *)optionsView {
    if (!_optionsView) {
        _optionsView = [[DMVoteOptionsView alloc] initWithInfo:self.info];
    }
    return _optionsView;
}

- (DMEntryCommitView *)commitView {
    if (!_commitView) {
        _commitView = [[DMEntryCommitView alloc] init];
        _commitView.lcHeight = 64;
        [_commitView setCommitTitle:NSLocalizedString(@"vote", @"投票")];
        __weak typeof(self) weakSelf = self;
        _commitView.clickCommitBlock = ^{
            NSLog(@"commit");
            [AppWindow endEditing:YES];
            [weakSelf vote];
        };
    }
    return _commitView;
}

- (void)vote {
    NSString *optionId = [self.optionsView getOptionIds];
    if ([optionId isEqualToString:@""]) {
        showToast(NSLocalizedString(@"vote_option_empty", @"请选择投票项"));
        return;
    }
    DMSubmitVoteRequester *requester = [[DMSubmitVoteRequester alloc] init];
    requester.voteId = self.info.vId;
    requester.optionId = optionId;
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

@end
