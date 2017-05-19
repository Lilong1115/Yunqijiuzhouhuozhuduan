//
//  CallPhone.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/20.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "CallPhone.h"

@implementation CallPhone

+ (void)callPhoneWithPhoneStr:(NSString *)phoneStr {
    
    // 这种拨打电话的写法，真机可显示效果，模拟器不显示
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}

@end
