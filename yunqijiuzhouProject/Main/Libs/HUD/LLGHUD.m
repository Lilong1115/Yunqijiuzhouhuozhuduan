//
//  LLGHUD.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/20.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "LLGHUD.h"

@implementation LLGHUD

+ (void)showSuccessWithStatus:(NSString *)status {

    [SVProgressHUD showSuccessWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showErrorWithStatus:(NSString *)status {
    
    [SVProgressHUD showErrorWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showWithStatus:(NSString *)status {
    
    [SVProgressHUD showWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showInfoWithStatus:(NSString *)status {
    
    [SVProgressHUD showInfoWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}





@end
