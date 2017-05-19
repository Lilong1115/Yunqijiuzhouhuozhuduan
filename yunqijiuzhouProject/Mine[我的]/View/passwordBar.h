//
//  passwordBar.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface passwordBar : UIToolbar

//完成回调
@property (nonatomic, copy) void(^completeBlock)();

//密码
@property (nonatomic, copy) NSString *password;

@end
