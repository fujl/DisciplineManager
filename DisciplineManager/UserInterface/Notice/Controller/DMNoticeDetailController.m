//
//  DMNoticeDetailController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticeDetailController.h"
#import "DMReadSignNoticeRequester.h"

@interface DMNoticeDetailController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DMNoticeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.noticeInfo.title;
    
    if (!self.isReadSign) {
        // 去读取
        [self readNotice];
    }
    
    self.contentLabel.text = self.noticeInfo.content;
    [self.subviewList addObject:self.contentLabel];
    [self setChildViews:self.subviewList];
}

- (void)readNotice {
    DMReadSignNoticeRequester *requester = [[DMReadSignNoticeRequester alloc] init];
    requester.noticeId = self.noticeInfo.noticeId;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code != ResultCodeOK) {
            NSLog(@"%@", data);
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

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.lcTopMargin = 10;
        _contentLabel.lcBottomMargin = 10;
        _contentLabel.lcRightMargin = 10;
        _contentLabel.lcLeftMargin = 10;
    }
    return _contentLabel;
}

@end
