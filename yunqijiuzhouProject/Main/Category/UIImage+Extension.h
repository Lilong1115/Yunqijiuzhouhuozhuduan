//
//  UIImage+Extension.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
