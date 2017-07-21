//
//  BABar.m
//  ZTRadida
//
//  Created by zhangtong on 16/6/12.
//  Copyright © 2016年 zhangtong. All rights reserved.
//


#import "UserInfo.h"
#import "NSString+Hash.h"
#define BABarAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation UserInfo


+ (UserInfo *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


+ (void)loginWithPhone:(NSString *)phone password:(NSString *)password {

    NSString *token = GetJPushToken;
    
    NSDictionary *parameters = @{
                                 @"phone":phone,
                                 @"password":[password md5String],
                                 @"token":token,
                                 @"yhlx":@"2",
                                 @"type":@"1"
                                 };
    
 
    NSString *json = [NSString ObjectTojsonString:parameters];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *dict = @{@"basic": jsonBase64};
    
    //NSLog(@"%@", jsonBase64);

    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:Login_URL andParameters:dict andSuccessBlock:^(id result) {
        
        NSLog(@"---------%@", result);
        
        if ([result[@"msg"] isEqualToString:@"成功"]) {
            
            NSArray *array = result[@"data"];
            NSDictionary *userDict = array.firstObject;
            
            id photo = userDict[@"photo"];
            if ([photo isKindOfClass:[NSNull class]]) {
                
            } else {
            
                NSString *photos = (NSString *)photo;
                
                if (photos.length > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:photos forKey:@"userPhoto"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            
            
            XBAccount *account = [XBAccount accountWithDic:userDict];
            
            [UserInfo saveAccount:account];
            
            //NSLog(@"登陆成功");
            
            [LLGHUD showSuccessWithStatus:@"登陆成功"];
            
        } else {
        
            [LLGHUD showErrorWithStatus:@"手机号或密码错误"];
        }
        
    } andFailBlock:^(NSError *error) {
        
        //NSLog(@"%@", error);
        
        [LLGHUD showErrorWithStatus:@"网络请求错误"];
    }];
    
}



//保存账号
+ (void)saveAccount:(XBAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:BABarAccountFile];
    
}
//读取账号
+ (XBAccount *)account
{
    // 取出账号
    XBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:BABarAccountFile];
    
    return account;

}
//删除用户信息
+(void)removeAccount{
    // 文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 从沙河删除
    [fileManager removeItemAtPath:BABarAccountFile error:nil];
}

//销毁账户
+(void)logoutAccount
{
    
    NSString *token = GetJPushToken;
    
    NSDictionary *parameters = @{
                                 @"phone":[UserInfo account].phone,
                                 @"token":token
                                 };
    
    NSString *json = [NSString ObjectTojsonString:parameters];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *dict = @{@"basic": jsonBase64};
    
    //NSLog(@"%@", jsonBase64);
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:Quit_URL andParameters:dict andSuccessBlock:^(id result) {
        
        NSLog(@"%@", result[@"msg"]);
        
        if ([result[@"msg"] isEqualToString:@"成功"]) {
            
            NSFileManager *fileManeger=[NSFileManager defaultManager];
            if ([fileManeger isDeletableFileAtPath:BABarAccountFile]) {
                [fileManeger removeItemAtPath:BABarAccountFile error:nil];
                //[MBProgressHUD showSuccess:@"注销成功"];
                
            }
            
            [LLGHUD showSuccessWithStatus:@"退出成功"];
            
        } else {
            
            [LLGHUD showErrorWithStatus:@"退出失败"];
        }
        
    } andFailBlock:^(NSError *error) {
        
        
    }];
    
    
}

+ (void)logout {
    
    NSFileManager *fileManeger=[NSFileManager defaultManager];
    if ([fileManeger isDeletableFileAtPath:BABarAccountFile]) {
        [fileManeger removeItemAtPath:BABarAccountFile error:nil];
    }
}


@end
