//
//  XSJNetworkTool.h
//  salesPlatform
//
//  Created by 李龙 on 17/3/6.
//  Copyright © 2017年 xiaoshoujia.com.cn. All rights reserved.
//

#import "AFNetworking.h"

//网络类型
typedef enum: NSUInteger{
    GET,
    POST,
}RequestType;

//成功block
typedef void(^SucessBlock)(id result);
//失败block
typedef void(^FailBlock)(NSError *error);

@interface XSJNetworkTool : AFHTTPSessionManager

+(instancetype)sharedNetworkTool;

//请求数据
- (void)requestDataWithRequestType:(RequestType)type andUrlString:(NSString *)UrlString andParameters:(id)parameters andSuccessBlock:(SucessBlock)sucess andFailBlock:(FailBlock)fail;



@end
