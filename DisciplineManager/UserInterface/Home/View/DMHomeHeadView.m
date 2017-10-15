//
//  DMHomeHeadView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/3.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHomeHeadView.h"
#import "DMMainItemView.h"

#define  kLogoHeight    (SCREEN_WIDTH*0.618)
@interface DMHomeHeadView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@end

@implementation DMHomeHeadView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.logoView];
        [self addSubview:self.contentView];
        CGFloat h = 0;
        for (NSInteger i=kMainItemTodo; i < 1008; i++) {
            NSString *title;
            NSString *icon;
            switch (i) {
                case kMainItemTodo:
                    title = NSLocalizedString(@"Todo", @"待办任务");
                    icon = @"ic_task";
                    break;
                case kMainItemApplyOut:
                    title = NSLocalizedString(@"ApplyOut", @"外出申请");
                    icon = @"ic_goout";
                    break;
                case kMainItemTemporaryTask:
                    title = NSLocalizedString(@"temporary_task", @"督办任务");
                    icon = @"ic_temporary_task";
                    break;
                case kMainItemExhibition:
                    title = NSLocalizedString(@"exhibition", @"工作展晒");
                    icon = @"ic_exhibition";
                    break;
                case kMainItemApplyLeave:
                    title = NSLocalizedString(@"ApplyLeave", @"请假申请");
                    icon = @"ic_leave";
                    break;
                case kMainItemApplyCompensatory:
                    title = NSLocalizedString(@"ApplyCompensatory", @"补休申请");
                    icon = @"ic_compenstaed_leave";
                    break;
                case kMainItemRepast:
                    title = NSLocalizedString(@"repast", @"就餐管理");
                    icon = @"ic_repast";
                    break;
                default:
                    title = NSLocalizedString(@"notice", @"通知公告");
                    icon = @"ic_notice";
                    break;
            }
            
            DMMainItemView *mainItemView = [self getMainItemView:i title:title icon:icon];
            [mainItemView addTarget:self action:@selector(clickMainItemView:) forControlEvents:UIControlEventTouchUpInside];
            NSInteger index = i-kMainItemTodo;
            CGFloat x = (index%4)*(mainItemView.width+0.5);
            CGFloat y = (index/4)*(mainItemView.height+0.5);
            mainItemView.frame = CGRectMake(x, y, mainItemView.width, mainItemView.height);
            if (i == kMainItemTodo) {
                self.todoView = mainItemView;
            }
            [self.contentView addSubview:mainItemView];
            h = y + mainItemView.height + 0.5;
        }
        self.contentView.frame = CGRectMake(0, kLogoHeight, SCREEN_WIDTH, h);
        self.height = h + kLogoHeight;
    }
    return self;
}

#pragma mark - getters and setters
- (SDCycleScrollView *)logoView {
    if (!_logoView) {
        NSArray *urls = @[/*[NSURL URLWithString:@"http://img2.imgtn.bdimg.com/it/u=1917120263,2189330565&fm=11&gp=0.jpg"],
                           [NSURL URLWithString:@"http://gbres.dfcfw.com/Files/picture/20140507/size500/024FDDE0195A318FC88E185936C1A24D.jpg"],
                           [NSURL URLWithString:@"http://i0.peopleurl.cn/nmsgimage/20150924/b_12511282_1443057242001.jpg"],
                           [NSURL URLWithString:@"http://i0.peopleurl.cn/nmsgimage/20150626/b_12511282_1435306319621.jpg"]*/];
        _logoView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kLogoHeight) delegate:self placeholderImage:[UIImage imageNamed:@"icon_error"]];
        
        _logoView.infiniteLoop = YES;
        _logoView.autoScrollTimeInterval = 5;
        _logoView.imageURLStringsGroup = urls;
    }
    return _logoView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (DMMainItemView *)getMainItemView:(NSInteger)tag title:(NSString *)title icon:(NSString *)icon {
    DMMainItemView *mainItemView = [[DMMainItemView alloc] initWithIcon:icon];
    mainItemView.tag = tag;
    [mainItemView setTitleViewText:title];
    return mainItemView;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    [self.logoView setImageURLStringsGroup:imageURLStringsGroup];
    self.logoView.delegate = self;
}

#pragma mark -
- (void)clickMainItemView:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (self.clickItemEvent) {
        self.clickItemEvent(tag);
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(index);
    }
}

@end
