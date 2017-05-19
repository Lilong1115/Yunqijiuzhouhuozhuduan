//
//  XSJScrollrecommendationView.m
//  salesPlatform
//
//  Created by 李龙 on 17/3/7.
//  Copyright © 2017年 xiaoshoujia.com.cn. All rights reserved.
//

#import "XSJScrollrecommendationView.h"
#import "XSJRecommendationButton.h"

@interface XSJScrollrecommendationView()

//被选中按钮
@property (nonatomic, strong) XSJRecommendationButton *selectedButton;

@property (nonatomic, weak) XSJRecommendationButton *todayRecommendationButton;
@property (nonatomic, weak) XSJRecommendationButton *offlineRecommendationButton;
@property (nonatomic, weak) XSJRecommendationButton *onlineRecommendationButton;


@end

@implementation XSJScrollrecommendationView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    
    return self;
}

//设置布局
- (void)setupUI {

    //今日推荐
    XSJRecommendationButton *todayRecommendationButton = [self creatButtonWithText:@"已发布"];
    todayRecommendationButton.lineHidden = NO;
    todayRecommendationButton.selected = YES;
    self.selectedButton = todayRecommendationButton;
    self.todayRecommendationButton = todayRecommendationButton;
    
    //线下
    XSJRecommendationButton *offlineRecommendationButton = [self creatButtonWithText:@"已签约"];
    offlineRecommendationButton.lineHidden = YES;
    self.offlineRecommendationButton = offlineRecommendationButton;
    
    //线上
    XSJRecommendationButton *onlineRecommendationButton = [self creatButtonWithText:@"已完成"];
    onlineRecommendationButton.lineHidden = YES;
    self.onlineRecommendationButton = onlineRecommendationButton;
    
    //设置tag值
    todayRecommendationButton.tag = selectedTypeTodayRecommendation;
    offlineRecommendationButton.tag = selectedTypeOfflineRecommendation;
    onlineRecommendationButton.tag = selectedTypeOnlineRecommendation;
    
    [todayRecommendationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(offlineRecommendationButton.mas_leading);
    }];
    [offlineRecommendationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(todayRecommendationButton.mas_trailing);
        make.top.bottom.mas_equalTo(todayRecommendationButton);
        make.width.mas_equalTo(todayRecommendationButton);
    }];
    [onlineRecommendationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(offlineRecommendationButton.mas_trailing);
        make.top.bottom.mas_equalTo(offlineRecommendationButton);
        make.width.mas_equalTo(offlineRecommendationButton);
    }];
}

//创建按钮
- (XSJRecommendationButton *)creatButtonWithText:(NSString *)text {

    XSJRecommendationButton *button = [XSJRecommendationButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateSelected];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:button];
    
    return button;
}

//按钮点击事件
- (void)clickButton:(XSJRecommendationButton *)button {

    self.selectedButton.selected = NO;
    self.selectedButton.lineHidden = YES;
    button.selected = YES;
    self.selectedButton = button;
    button.lineHidden = NO;
    
    //调用
    self.clickTypeBlock(button.tag);
}

//通过页码设置按钮选中状态
- (void)setClickNum:(NSInteger)clickNum {

    _clickNum = clickNum;
    switch (clickNum) {
        case selectedTypeTodayRecommendation - 1000:
            [self clickButton:self.todayRecommendationButton];
            break;
        case selectedTypeOfflineRecommendation - 1000:
            [self clickButton:self.offlineRecommendationButton];
            break;
        case selectedTypeOnlineRecommendation - 1000:
            [self clickButton:self.onlineRecommendationButton];
            break;
    }
}


- (void)setFirstButtonTitle:(NSString *)firstButtonTitle {

    _firstButtonTitle = firstButtonTitle;
    
    [self.todayRecommendationButton setTitle:firstButtonTitle forState:UIControlStateNormal];
    [self.todayRecommendationButton setTitle:firstButtonTitle forState:UIControlStateSelected];
    
    self.todayRecommendationButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSecondButtonTitle:(NSString *)secondButtonTitle {

    _secondButtonTitle = secondButtonTitle;
    
    [self.offlineRecommendationButton setTitle:secondButtonTitle forState:UIControlStateNormal];
    [self.offlineRecommendationButton setTitle:secondButtonTitle forState:UIControlStateSelected];
    
    self.offlineRecommendationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)setThirdButtonTitle:(NSString *)thirdButtonTitle {

    _thirdButtonTitle = thirdButtonTitle;
    
    [self.onlineRecommendationButton setTitle:thirdButtonTitle forState:UIControlStateNormal];
    [self.onlineRecommendationButton setTitle:thirdButtonTitle forState:UIControlStateSelected];
    
    self.onlineRecommendationButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

@end
