//
//  WithdrawalView.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountTypeModel;

@interface WithdrawalView : UIView

@property (nonatomic, strong) AccountTypeModel *accountTypeModel;

//提现金额
@property (nonatomic, copy) NSString *money;

//余额
@property (nonatomic, copy) NSString *totalMoney;

//全部提现回调
@property (nonatomic, copy) void(^totalMoneyBlock)();

@end
