//
//  LLGHUD.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/20.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLGHUD : NSObject

+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status;
+ (void)showInfoWithStatus:(NSString *)status;
@end
