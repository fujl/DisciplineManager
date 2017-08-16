//
//  DMAddressPickerView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAddressPickerView.h"

#define kComponentProvince  0
#define kComponentCity      1
#define kComponentArea      2

#define kDefaultProvinceId  2585
#define kDefaultCityId      2644
#define kDefaultAreaId      2645

@interface DMAddressPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *backgroundView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) MASConstraint *bottomConstraint;

@property (nonatomic, strong) NSMutableArray<DMAddressInfo *> *provinceList;
@property (nonatomic, strong) NSMutableArray<DMAddressInfo *> *cityList;
@property (nonatomic, strong) NSMutableArray<DMAddressInfo *> *areaList;

@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger areaId;

@end

@implementation DMAddressPickerView
#pragma mark - lifecycle
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.provinceId = 0;
        self.cityId = 0;
        self.areaId = 0;
        
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.backgroundView];
    [self addSubview:self.pickerView];
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.closeBtn];
    [self.titleView addSubview:self.completeBtn];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        _bottomConstraint = make.bottom.equalTo(self).offset(260);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.height.equalTo(@(40));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.left.top.height.equalTo(self.titleView);
    }];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.right.top.height.equalTo(self.titleView);
    }];
}

- (void)refreshData {
    [self.provinceList removeAllObjects];
    DMAddressManager *manager = getManager([DMAddressManager class]);
    [manager getAllAddress:^(NSMutableArray<DMAddressInfo *> *addressList) {
        [self.provinceList addObjectsFromArray:addressList];
        NSInteger row = 0;
        if (self.provinceId > 0) {
            row = [self getComponent:self.provinceList addressId:self.provinceId];
        }
        [self.pickerView reloadComponent:kComponentProvince];
        [self.pickerView selectRow:row inComponent:kComponentProvince animated:YES];
        
        DMAddressInfo *province = [self.provinceList objectAtIndex:row];
        [self reloadCityInfo:province];
    }];
}

#pragma mark - getters and setters
- (UIButton *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIButton alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.4f];
        _backgroundView.alpha = 0;
        [_backgroundView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.userInteractionEnabled = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor colorWithRGB:0xF0F0F0];
    }
    return _titleView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:NSLocalizedString(@"Close", @"关闭") forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithRGB:0x808080] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithRGB:0x222222] forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [[UIButton alloc] init];
        [_completeBtn setTitle:NSLocalizedString(@"Complete", @"完成") forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x808080] forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithRGB:0x222222] forState:UIControlStateHighlighted];
        [_completeBtn addTarget:self action:@selector(onCompleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

- (NSMutableArray<DMAddressInfo *> *)provinceList {
    if (!_provinceList) {
        _provinceList = [[NSMutableArray<DMAddressInfo *> alloc] init];
    }
    return _provinceList;
}

- (NSMutableArray<DMAddressInfo *> *)cityList {
    if (!_cityList) {
        _cityList = [[NSMutableArray<DMAddressInfo *> alloc] init];
    }
    return _cityList;
}

- (NSMutableArray<DMAddressInfo *> *)areaList {
    if (!_areaList) {
        _areaList = [[NSMutableArray<DMAddressInfo *> alloc] init];
    }
    return _areaList;
}

#pragma mark - event method
- (void)dismiss {
    self.bottomConstraint.offset(260);
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onCompleteBtnClick {
    NSInteger provinceRow = [self.pickerView selectedRowInComponent:0];
    NSInteger cityRow = [self.pickerView selectedRowInComponent:1];
    NSInteger areaRow = [self.pickerView selectedRowInComponent:2];
    
    DMAddressInfo *tmpProvinceInfo = [self.provinceList objectAtIndex:provinceRow];
    DMAddressInfo *tmpCityInfo = [self.cityList objectAtIndex:cityRow];
    DMAddressInfo *tmpAreaInfo = [self.areaList objectAtIndex:areaRow];
    
    BOOL isUpdate = YES;
    if (self.provinceId > 0) {
        isUpdate = self.provinceId!= tmpProvinceInfo.addressId;
    }
    if (self.cityId > 0) {
        isUpdate = self.cityId != tmpCityInfo.addressId;
    }
    if (self.areaId > 0) {
        isUpdate = self.areaId != tmpAreaInfo.addressId;
    }
    if (isUpdate) {
        if (self.onCompleteClick) {
            self.onCompleteClick(tmpProvinceInfo, tmpCityInfo, tmpAreaInfo);
        }
    } else {
        // 默认值
        if (tmpProvinceInfo.addressId == kDefaultProvinceId && tmpCityInfo.addressId == kDefaultCityId && tmpAreaInfo.addressId == kDefaultAreaId) {
            if (self.onCompleteClick) {
                self.onCompleteClick(tmpProvinceInfo, tmpCityInfo, tmpAreaInfo);
            }
        }
    }
    [self dismiss];
}

#pragma mark - public method
- (void)show {
    [AppWindow addSubview:self];
    [AppWindow endEditing:YES];
    [self layoutIfNeeded];
    self.bottomConstraint.offset(0);
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundView.alpha = 1;
        [self layoutIfNeeded];
    }];
}

- (void)selected:(NSInteger)provinceId city:(NSInteger)cityId area:(NSInteger)areaId {
    self.provinceId = provinceId;
    self.cityId = cityId;
    self.areaId = areaId;
}

#pragma mark - UIPickerViewDelegate UIPickerViewDataSource
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;// 返回3表明该控件只包含3列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回各列的行数，表明包含多少个元素，该控件就包含多少行
    if (component == 0) {
        return self.provinceList.count;
    } else if (component == 1) {
        return self.cityList.count;
    } else {
        return self.areaList.count;
    }
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        DMAddressInfo *province = [self.provinceList objectAtIndex:row];
        [self reloadCityInfo:province];
    } else if (component == 1) {
        DMAddressInfo *city = [self.cityList objectAtIndex:row];
        [self reloadAreaInfo:city.addressId];
    } else {
        //return self.areaList.count;
    }
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        DMAddressInfo *provinceInfo = [self.provinceList objectAtIndex:row];
        return provinceInfo.name;
    } else if (component == 1) {
        DMAddressInfo *cityInfo = [self.cityList objectAtIndex:row];
        return cityInfo.name;
    } else {
        DMAddressInfo *areaInfo = [self.areaList objectAtIndex:row];
        return areaInfo.name;
    }
}

- (void)reloadCityInfo:(DMAddressInfo *)province {
    [self.cityList removeAllObjects];
    DMAddressManager *manager = getManager([DMAddressManager class]);
    if (province.type == AddressTypeCity) {
        [self.cityList addObject:province];
        NSInteger row = 0;
        if (self.cityId > 0) {
            row = [self getComponent:self.cityList addressId:self.cityId];
        }
        [self.pickerView reloadComponent:kComponentCity];
        [self.pickerView selectRow:row inComponent:kComponentCity animated:YES];
        DMAddressInfo *firstInfo = [self.cityList objectAtIndex:row];
        [self reloadAreaInfo:firstInfo.addressId];
    } else {
        [manager getAddressInfoList:province.addressId callback:^(NSMutableArray<DMAddressInfo *> *addressList) {
            [self.cityList addObjectsFromArray:addressList];
            NSInteger row = 0;
            if (self.cityId > 0) {
                row = [self getComponent:self.cityList addressId:self.cityId];
            }
            [self.pickerView reloadComponent:kComponentCity];
            [self.pickerView selectRow:row inComponent:kComponentCity animated:YES];
            
            DMAddressInfo *firstInfo = [self.cityList objectAtIndex:row];
            [self reloadAreaInfo:firstInfo.addressId];
        }];
    }
}

- (void)reloadAreaInfo:(NSInteger)pid {
    [self.areaList removeAllObjects];
    DMAddressManager *manager = getManager([DMAddressManager class]);
    [manager getAddressInfoList:pid callback:^(NSMutableArray<DMAddressInfo *> *addressList) {
        [self.areaList addObjectsFromArray:addressList];
        NSInteger row = 0;
        if (self.areaId > 0) {
            row = [self getComponent:self.areaList addressId:self.areaId];
        }
        [self.pickerView reloadComponent:kComponentArea];
        [self.pickerView selectRow:row inComponent:kComponentArea animated:YES];
    }];
}

#pragma mark - private method
- (NSInteger)getComponent:(NSArray<DMAddressInfo *> *)addressList addressId:(NSInteger)addressId {
    NSInteger component = 0;
    for (NSInteger i=0; i<addressList.count; i++) {
        DMAddressInfo *info = [addressList objectAtIndex:i];
        if (info.addressId == addressId) {
            component = i;
            break;
        }
    }
    return component;
}
@end
