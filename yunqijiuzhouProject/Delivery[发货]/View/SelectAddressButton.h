//
//  SelectAddressButton.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAddressButton : UIButton

//外部设置文字
@property (nonatomic, copy) NSString *headline;
//内容
@property (nonatomic, copy) NSString *contentText;
//颜色
@property (nonatomic, strong) UIColor *headlineColor;

@end
