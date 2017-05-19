//
//  AccountBindingViewController.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/6.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountBindingViewController : UIViewController

//url
@property (nonatomic, copy) NSString *urlStr;

//
@property (nonatomic, copy) NSString *ywlx;

//公账余额
@property (nonatomic, copy) NSString *gzzhMoney;
//个人余额
@property (nonatomic, copy) NSString *grzhMoney;

@end
