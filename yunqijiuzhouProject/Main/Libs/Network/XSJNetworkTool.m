//
//  XSJNetworkTool.m
//  salesPlatform
//
//  Created by 李龙 on 17/3/6.
//  Copyright © 2017年 xiaoshoujia.com.cn. All rights reserved.
//

#import "XSJNetworkTool.h"


@implementation XSJNetworkTool

static XSJNetworkTool *_instanceType;
+(instancetype)sharedNetworkTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc]init];
        
        //https
        AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
       
        [policy setValidatesDomainName:NO];
        _instanceType.securityPolicy = policy;
        
        //修改AFN支持向服务器发送JSON形式的二进制数据
        //_instanceType.requestSerializer = [AFJSONRequestSerializer serializer];
        //接收到的数据是二进制
        _instanceType.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _instanceType.responseSerializer.acceptableContentTypes = [_instanceType.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        
    });
    return _instanceType;
}


- (void)netWorkToolWithRequestType:(RequestType)type andUrlString:(NSString *)UrlString andParameter:(id)parameters andSuccessBlock:(SucessBlock)sucess andFailBlock:(FailBlock)fail{
    
    if (type == GET) {
        [self GET:UrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            sucess(dict);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            [LLGHUD showErrorWithStatus:@"网络请求错误"];
            
        }];
    } else {
    
        [self POST:UrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            sucess(dict);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [LLGHUD showErrorWithStatus:@"网络请求错误"];
            
        }];
        
    }
    
}

- (void)requestDataWithRequestType:(RequestType)type andUrlString:(NSString *)UrlString andParameters:(id)parameters andSuccessBlock:(SucessBlock)sucess andFailBlock:(FailBlock)fail {

    [self netWorkToolWithRequestType:type andUrlString:UrlString andParameter:parameters andSuccessBlock:sucess andFailBlock:fail];
}

@end
