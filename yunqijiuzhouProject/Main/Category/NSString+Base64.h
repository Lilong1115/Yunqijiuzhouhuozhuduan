//
//  NSString+Base64.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/22.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (Base64)
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;
@end
