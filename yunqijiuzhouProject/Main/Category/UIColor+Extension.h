//
//  UIColor+Extension.h
//  salesPlatform
//
//  Created by 李龙 on 17/3/6.
//  Copyright © 2017年 xiaoshoujia.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithWholeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
