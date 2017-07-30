//
//  DMDatePickerView.m
//  DM
//
//  Created by fujl-mac on 2017/4/6.
//  Copyright © 2017年 Micheal Jordan. All rights reserved.
//

#import "DMDatePickerView.h"

@implementation DMDateTypeModel

@end

@interface DMDatePickerView ()  <UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic,strong) UIButton *backgroundView;

@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIButton *completeBtn;
@property(nonatomic, strong) MASConstraint *bottomConstraint;
@property (nonatomic, strong) UIPickerView *dateTypePicker;
@property (nonatomic, strong) NSMutableArray<DMDateTypeModel *> *dateTypeSource;

@property (nonatomic, assign) DMDateType dateType;
@end

@implementation DMDatePickerView

- (instancetype)initWithDateType:(DMDateType)dateType {
    self.dateType = dateType;
    return [self init];
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        _backgroundView = [[UIButton alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.4f];
        _backgroundView.alpha = 0;
        [_backgroundView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.datePicker];
        if (self.dateType != DMDateTypeNone) {
            [self addSubview:self.dateTypePicker];
            
            [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.width.equalTo(@(SCREEN_WIDTH*3/4.0f));
                _bottomConstraint = make.bottom.equalTo(self).offset(260);
            }];
            
            [self.dateTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.datePicker.mas_right);
                make.right.equalTo(self.mas_right);
                make.top.equalTo(self.datePicker);
                make.height.equalTo(self.datePicker);
            }];
            
            [self.dateTypePicker reloadAllComponents];
            NSInteger row = 0;
            for (NSInteger i=0; i<self.dateTypeSource.count; i++) {
                DMDateTypeModel *mdl = [self.dateTypeSource objectAtIndex:i];
                if (mdl.dateType == self.dateType) {
                    row = i;
                    break;
                }
            }
            [self.dateTypePicker selectRow:row inComponent:0 animated:YES];
        } else {
            [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                _bottomConstraint = make.bottom.equalTo(self).offset(260);
            }];
        }
        
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor colorWithRGB:0xF0F0F0];
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(_datePicker.mas_top);
            make.height.equalTo(@(40));
        }];
        
        _closeBtn = [[UIButton alloc] init];
        
        [_closeBtn setTitle:NSLocalizedString(@"Close", @"关闭") forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithRGB:0x808080] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithRGB:0x222222] forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.left.top.height.equalTo(titleView);
        }];
        
        _completeBtn = [[UIButton alloc] init];
        [_completeBtn setTitle:NSLocalizedString(@"Complete", @"完成") forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x808080] forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x222222] forState:UIControlStateHighlighted];
        [_completeBtn addTarget:self action:@selector(onCompleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:_completeBtn];
        [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.right.top.height.equalTo(titleView);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _datePicker;
}

- (NSMutableArray *)dateTypeSource {
    if (!_dateTypeSource) {
        _dateTypeSource = [[NSMutableArray alloc] init];
        
        DMDateTypeModel *morning = [[DMDateTypeModel alloc] init];
        morning.dateType = DMDateTypeMorning;
        morning.name = NSLocalizedString(@"morning", @"上午");
        [_dateTypeSource addObject:morning];
        
        DMDateTypeModel *afternoon = [[DMDateTypeModel alloc] init];
        afternoon.dateType = DMDateTypeAfternoon;
        afternoon.name = NSLocalizedString(@"afternoon", @"上午");
        [_dateTypeSource addObject:afternoon];
    }
    return _dateTypeSource;
}

- (UIPickerView *)dateTypePicker {
    if (!_dateTypePicker) {
        _dateTypePicker = [[UIPickerView alloc] init];
        _dateTypePicker.delegate = self;
        _dateTypePicker.dataSource = self;
        _dateTypePicker.backgroundColor = [UIColor whiteColor];
    }
    return _dateTypePicker;
}

- (void)onCompleteBtnClick{
    NSDate *date = self.datePicker.date;
    if (self.dateType != DMDateTypeNone) {
        if (self.onCompleteDtClick) {
            NSInteger dateTypeRow = [self.dateTypePicker selectedRowInComponent:0];
            DMDateTypeModel *dtModel = [self.dateTypeSource objectAtIndex:dateTypeRow];
            self.onCompleteDtClick(self, date, dtModel);
        }
    } else {
        if(self.onCompleteClick){
            self.onCompleteClick(self, date);
        }
    }
    [self dismiss];
}

-(void)show{
    [AppWindow addSubview:self];
    [AppWindow endEditing:YES];
    [self layoutIfNeeded];
    _bottomConstraint.offset(0);
    [UIView animateWithDuration:0.4 animations:^{
        _backgroundView.alpha = 1;
        [self layoutIfNeeded];
    }];
}

-(void)dismiss{
    _bottomConstraint.offset(260);
    [UIView animateWithDuration:0.4 animations:^{
        _backgroundView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)setCompleteTitle:(NSString *)title{
    [_completeBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - UIPickerViewDataSource
// 该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;// 返回3表明该控件只包含3列
}

// 该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回各列的行数，表明包含多少个元素，该控件就包含多少行
    return self.dateTypeSource.count;
}

// 指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark - UIPickerViewDelegate
// 该方法返回的NSString将作为UIPickerView 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    DMDateTypeModel *mdl = [self.dateTypeSource objectAtIndex:row];
    return mdl.name;
}
@end
