//
//  MsgInterviewImageContainer.h
//  Health
//
//  Created by linxingxi on 16/10/21.
//  Copyright © 2016年 longmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgInterviewImageContainer : UIView

@property(nonatomic, strong, readonly) NSArray<NSString *> *pictures;
@property(nonatomic, copy) void (^choosePicture)();
@property(nonatomic, copy) void (^empty)();
@property(nonatomic, assign) BOOL haveChange;                       //是否被修改过(从外部设置数据后)
- (instancetype)initWithMaxImageCount:(NSInteger)count columns:(NSInteger)columns itemMargin:(NSInteger)margin;

- (void)addItem:(NSString *)picturePath;

- (void)removeAllPictures;

@end
