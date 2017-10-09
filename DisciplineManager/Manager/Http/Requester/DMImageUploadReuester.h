//
//  DMImageUploadReuester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/5.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMImageUploadReuester : NSObject
- (void)upload:(NSString *)imagePath  isFace:(BOOL)isFace callback:(void (^)(DMResultCode code, id data))callback;
@end
