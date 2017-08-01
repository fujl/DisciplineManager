//
//  DMPickerView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMPickerView.h"

#define cellHeight 44

@interface DMPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView * pickerView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign) NSInteger index;

@end

@implementation DMPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithARGB:0x22000000];
        [self createUI];
        
        [self addGesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    }
    return self;
}

- (instancetype)initWithArr:(NSArray <__kindof NSDictionary *> *)dataArr {
    self = [self init];
    if (self) {
        self.dataArr = [dataArr mutableCopy];
    }
    return self;
}

- (instancetype)initWithEnglishTitleArr:(NSArray <__kindof NSString *> *)titleArr {
    self = [self init];
    if (self) {
        for (NSString *str in titleArr) {
            [self.dataArr addObject:NSLocalizedString(str, "")];
        }
    }
    return self;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClicked)];
    [self addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * leftAndRightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftAndRightSwipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftAndRightSwipe];
    
    UISwipeGestureRecognizer * upAndDownSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    upAndDownSwipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:upAndDownSwipe];
}

- (void)handleSwipe:(UIGestureRecognizer *)gesture{
    [self hiddenPickerView];
}

- (void)createUI{
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    
    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:cancelBtn];
    [topView addSubview:submitBtn];
    [topView addSubview:bottomLine];
    [self addSubview:topView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@180);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(topView);
        make.width.equalTo(@50);
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(topView);
        make.width.equalTo(@50);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView.mas_bottom);
        make.left.equalTo(topView);
        make.width.equalTo(bottomLine);
        make.height.equalTo(@(0.5));
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.height.equalTo(@44);
    }];
}

- (void)cancelClicked {
    [self hiddenPickerView];
}

- (void)submitBtnClicked {
    [self hiddenPickerView];
    if (self.onCompleteClick) {
        self.onCompleteClick(self.dataArr[self.index]);
    }
}

- (void)selectID:(NSString *)Id{
    int i = 0;
    for (NSDictionary *dic in self.dataArr) {
        if ([dic[@"value"] isEqualToString:Id]) {
            [self.pickerView selectRow:i inComponent:0 animated:YES];
        }
        i++;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return cellHeight;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dic = self.dataArr[row];
    return dic[@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.index = row;
}


#pragma mark - other
- (void)applicationWillResignActive:(NSNotification *)not {
    [self hiddenPickerView];
}

- (void)applicationDidBecomeActive:(NSNotification *)not {
    
}

- (void)showPickerView {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hiddenPickerView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeFromSuperview];
}

@end
