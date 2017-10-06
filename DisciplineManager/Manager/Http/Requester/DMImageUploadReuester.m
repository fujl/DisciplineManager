//
//  DMImageUploadReuester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/5.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMImageUploadReuester.h"
#import "DMNetworkManager.h"
#import "AFHTTPSessionManager.h"

@implementation DMImageUploadReuester

- (void)upload:(NSString *)imagePath callback:(void (^)(DMResultCode code, id data))callback {
    DMNetworkManager *netWorkManager = getManager(DMNetworkManager);
    if(![netWorkManager hasNet]){
        callback(ResultCodeNetError,nil);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", [[DMConfig mainConfig] getServerUrl], @"api/upload/images.do"];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    DMUserManager *userManager = getManager([DMUserManager class]);
    NSDictionary *headers = @{@"token":userManager.loginInfo.accessToken};
    if(headers){
        NSArray *keys = [headers allKeys];
        for(NSString *key in keys){
            [requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    sessionManager.requestSerializer = requestSerializer;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *fileImage = [UIImage imageWithContentsOfFile:imagePath];
        NSString *fileName = [imagePath lastPathComponent];
//        [formData appendPartWithFormData:UIImagePNGRepresentation(fileImage) name:fileName];
        [formData appendPartWithFileData:UIImagePNGRepresentation(fileImage) name:fileName fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"task:%@ responseObject:%@", task, responseObject);
        callback(ResultCodeOK, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task:%@ error:%@", task, error);
        callback(ResultCodeFailed, nil);
    }];
    
//    [sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        handler(YES, responseObject);
//    }             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        NSLog(@"WEB error = %@", error);
//        handler(NO, nil);
//    }];
}

@end
