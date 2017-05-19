//
//  XSJRecommendationButton.m
//  salesPlatform
//
//  Created by 李龙 on 17/3/7.
//  Copyright © 2017年 xiaoshoujia.com.cn. All rights reserved.
//
//下划线button
#import "XSJRecommendationButton.h"

@interface XSJRecommendationButton()

@property (nonatomic, weak) UIView *lineView;

@end

@implementation XSJRecommendationButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor redColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(2);
    }];
    
}

//设置是否隐藏下划线
- (void)setLineHidden:(BOOL)lineHidden {

    _lineHidden = lineHidden;
    
    self.lineView.hidden = lineHidden;
    
}

//设置下划线颜色
- (void)setLineColor:(UIColor *)lineColor {

    _lineColor = lineColor;
    
    self.lineView.backgroundColor = lineColor;
    
}

@end
