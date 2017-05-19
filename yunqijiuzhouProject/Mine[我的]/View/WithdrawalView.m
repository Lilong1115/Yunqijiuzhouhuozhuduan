//
//  WithdrawalView.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "WithdrawalView.h"
#import "AccountTypeModel.h"

@interface WithdrawalView()
//输入框
@property (nonatomic, weak) UITextField *withdrawalText;
//账户类型
@property (nonatomic, weak) UILabel *typeLabel;
//余额
@property (nonatomic, weak) UILabel *moneyLabel;

@end

@implementation WithdrawalView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {

    //提现金额
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"提现金额";
    //tipLabel.font = TextFont14;
    [self addSubview:tipLabel];
    //人民币
    UILabel *rmb = [[UILabel alloc]init];
    rmb.text = @"¥";
    rmb.textAlignment = NSTextAlignmentCenter;
    rmb.font = [UIFont systemFontOfSize:25];
    //rmb.backgroundColor = [UIColor redColor];
    [self addSubview:rmb];
    
    //输入框
    UITextField *withdrawalText = [[UITextField alloc]init];
    [self addSubview:withdrawalText];
    withdrawalText.keyboardType = UIKeyboardTypeDecimalPad;
    withdrawalText.font = [UIFont systemFontOfSize:30];
    self.withdrawalText = withdrawalText;
    
    UILabel *tip1 = [[UILabel alloc]init];
    tip1.text = @"当前";
    tip1.font = TextFont14;
    tip1.textColor = [UIColor lightGrayColor];
    [self addSubview:tip1];
    
    //账户类型
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.text = @"对公账户";
    typeLabel.font = TextFont14;
    typeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UILabel *tip2 = [[UILabel alloc]init];
    tip2.text = @"余额";
    tip2.font = TextFont14;
    tip2.textColor = [UIColor lightGrayColor];
    [self addSubview:tip2];
    
    //余额
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = @"50";
    moneyLabel.font = TextFont14;
    moneyLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *tip3 = [[UILabel alloc]init];
    tip3.text = @"元, ";
    tip3.font = TextFont14;
    tip3.textColor = [UIColor lightGrayColor];
    [self addSubview:tip3];
    
    //全部提现
    UIButton *totalMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    [totalMoney setTitle:@"全部提现" forState:UIControlStateNormal];
    [totalMoney setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    totalMoney.titleLabel.font = TextFont14;
    [self addSubview:totalMoney];
    [totalMoney addTarget:self action:@selector(totalMoney:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self).mas_offset(8);
    }];
    [rmb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(8);
        make.leading.mas_equalTo(tipLabel);
        make.width.mas_equalTo(30);
    }];
    [withdrawalText mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(8);
        make.centerY.mas_equalTo(rmb);
        make.leading.mas_equalTo(rmb.mas_trailing).mas_offset(8);
        make.trailing.mas_equalTo(self).mas_offset(-8);
    }];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(rmb);
        make.top.mas_equalTo(rmb.mas_bottom).mas_offset(8);
    }];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(tip1.mas_trailing);
        make.centerY.mas_equalTo(tip1);
    }];
    [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip1);
        make.leading.mas_equalTo(typeLabel.mas_trailing);
    }];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip1);
        make.leading.mas_equalTo(tip2.mas_trailing);
    }];
    [tip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip1);
        make.leading.mas_equalTo(moneyLabel.mas_trailing);
    }];
    [totalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip1);
        make.leading.mas_equalTo(tip3.mas_trailing);
    }];
}


//全部提现
- (void)totalMoney:(UIButton *)button {

    self.withdrawalText.text = self.moneyLabel.text;
    
    if (self.totalMoneyBlock != nil) {
        self.totalMoneyBlock();
    }
}

//设置余额
- (void)setTotalMoney:(NSString *)totalMoney {

    _totalMoney = totalMoney;
    self.moneyLabel.text = totalMoney;
}

//设置类型
- (void)setAccountTypeModel:(AccountTypeModel *)accountTypeModel {

    _accountTypeModel = accountTypeModel;
    
    self.typeLabel.text = accountTypeModel.account;
    
}

//获取金额
- (NSString *)money {

    return self.withdrawalText.text;
}

@end
