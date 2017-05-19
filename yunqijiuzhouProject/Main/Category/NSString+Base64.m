//
//  NSString+Base64.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/22.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "NSString+Base64.h"
@implementation NSString (Base64)

- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
