//
//  NSString+Extension.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/18.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


+ (NSString *)removeBlankSpace:(NSString *)object {

    NSMutableString *mutStr = [NSMutableString stringWithString:object];
    
    NSRange range = {0,object.length};
    
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    
    return mutStr;
}

//数据转成JsonString类型 去除空格和换行
+ (NSString *)ObjectTojsonString:(id)object {
    
    NSString *jsonString = [[NSString alloc]init];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        
        NSLog(@"error: %@", error);
        
    } else {
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

+ (NSString *)jsonBase64WithJson:(NSString *)json {
    
    return [[json dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

//创建时间字符串 "yyyy-MM-dd" -> "yyyyMMdd"
+ (NSString *)creatTimeStr:(NSString *)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *resDate = [formatter dateFromString:str];
    
    [formatter setDateFormat:@"yyyyMMdd"];
    
    //NSLog(@"%@",[formatter stringFromDate:resDate]);
    
    return [formatter stringFromDate:resDate];
    
}

@end
