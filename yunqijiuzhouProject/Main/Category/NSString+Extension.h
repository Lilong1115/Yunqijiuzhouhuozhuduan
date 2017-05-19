//
//  NSString+Extension.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/18.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)removeBlankSpace:(NSString *)object;

/* 数据转成JsonString类型 去除空格和换行 */
+ (NSString *)ObjectTojsonString:(id)object;

/* json base64加密 */
+ (NSString *)jsonBase64WithJson:(NSString *)json;

/* 创建时间字符串 "yyyy-MM-dd" -> "yyyyMMdd" */
+ (NSString *)creatTimeStr:(NSString *)str;

@end
