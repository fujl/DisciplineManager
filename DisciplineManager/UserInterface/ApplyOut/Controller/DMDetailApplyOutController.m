//
//  DMDetailApplyOutController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyOutController.h"
#import "DMDetailApplyOutRequester.h"
#import "DMApplyOutListInfo.h"

@interface DMDetailApplyOutController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMEntryView *outTimeTitleView;
@property (nonatomic, strong) DMDetailView *outTimeDetailView;
@property (nonatomic, strong) DMEntryView *returnTimeTitleView;
@property (nonatomic, strong) DMDetailView *returnTimeDetailView;
@property (nonatomic, strong) DMEntryView *outReasonTitleView;
@property (nonatomic, strong) DMDetailView *outReasonDetailView;
@end

@implementation DMDetailApplyOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ApplyOut",@"外出申请"), NSLocalizedString(@"Detail",@"详情")];
    [self refreshView];
}

- (void)refreshView {
    showLoadingDialog();
    [self getDetailInfo:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            DMApplyOutListInfo *info = data;
            self.outTimeDetailView.lcHeight = [self.outTimeDetailView getHeightFromDetail:info.startTime];
            self.returnTimeDetailView.lcHeight = [self.returnTimeDetailView getHeightFromDetail:info.endTime];
            self.outReasonDetailView.lcHeight = [self.outReasonDetailView getHeightFromDetail:info.reason];
            [self loadSubview];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)loadSubview {
    [self.subviewList removeAllObjects];
    
    [self.subviewList addObject:self.outTimeTitleView];
    [self.subviewList addObject:self.outTimeDetailView];
    
    [self.subviewList addObject:self.returnTimeTitleView];
    [self.subviewList addObject:self.returnTimeDetailView];
    
    [self.subviewList addObject:self.outReasonTitleView];
    [self.subviewList addObject:self.outReasonDetailView];
    
    [self setChildViews:self.subviewList];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMEntryView *)outTimeTitleView {
    if (!_outTimeTitleView) {
        _outTimeTitleView = [[DMEntryView alloc] init];
        [_outTimeTitleView setTitle:NSLocalizedString(@"OutTime", @"外出时间")];
        _outTimeTitleView.lcHeight = 44;
    }
    return _outTimeTitleView;
}

- (DMDetailView *)outTimeDetailView {
    if (!_outTimeDetailView) {
        _outTimeDetailView = [[DMDetailView alloc] init];
    }
    return _outTimeDetailView;
}

- (DMEntryView *)returnTimeTitleView {
    if (!_returnTimeTitleView) {
        _returnTimeTitleView = [[DMEntryView alloc] init];
        [_returnTimeTitleView setTitle:NSLocalizedString(@"ReturnTime", @"回岗时间")];
        _returnTimeTitleView.lcHeight = 44;
    }
    return _returnTimeTitleView;
}

- (DMDetailView *)returnTimeDetailView {
    if (!_returnTimeDetailView) {
        _returnTimeDetailView = [[DMDetailView alloc] init];
    }
    return _returnTimeDetailView;
}

- (DMEntryView *)outReasonTitleView {
    if (!_outReasonTitleView) {
        _outReasonTitleView = [[DMEntryView alloc] init];
        [_outReasonTitleView setTitle:NSLocalizedString(@"OutReason", @"外出事由")];
        _outReasonTitleView.lcHeight = 44;
    }
    return _outReasonTitleView;
}

- (DMDetailView *)outReasonDetailView {
    if (!_outReasonDetailView) {
        _outReasonDetailView = [[DMDetailView alloc] init];
    }
    return _outReasonDetailView;
}

#pragma mark - get data
- (void)getDetailInfo:(void (^)(DMResultCode code, id data))callback {
    DMDetailApplyOutRequester *requester = [[DMDetailApplyOutRequester alloc] init];
    requester.aoId = self.aoId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            callback(code, data);
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}
@end
