//
//  FirstTableViewCell.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

//出发地 目的地
#import "FirstTableViewCell.h"
#import "SelectAddressButton.h"
#import "cityModel.h"

@interface FirstTableViewCell()
//出发地
@property (nonatomic, weak) SelectAddressButton *startingButton;
//目的地
@property (nonatomic, weak) SelectAddressButton *endingButton;

@end


@implementation FirstTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        
    }
    
    return self;
}


- (void)setupUI {

    //交换图片
    UIImageView *exchangeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exchange"]];
    [self.contentView addSubview:exchangeImage];
    
    //出发地
    SelectAddressButton *startingButton = [self creatSelectButtonWithTitle:@"出发地:"];
    startingButton.tag = 100;
    self.startingButton = startingButton;
    //目的地
    SelectAddressButton *endingButton = [self creatSelectButtonWithTitle:@"目的地:"];
    endingButton.tag = 200;
    self.endingButton = endingButton;
    
    [exchangeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [startingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(exchangeImage.mas_leading).mas_offset(-8);
    }];
    [endingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(exchangeImage.mas_trailing).mas_offset(8);
        make.trailing.mas_equalTo(self.contentView).mas_offset(-8);
    }];
    
}

//创建按钮
- (SelectAddressButton *)creatSelectButtonWithTitle:(NSString *)title {

    SelectAddressButton *button = [[SelectAddressButton alloc]init];
    
    [button addTarget:self action:@selector(clickAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    
    button.headline = title;
    
    [self.contentView addSubview:button];
    
    return button;
    
}

- (void)clickAddressButton:(SelectAddressButton *)button {
    
    self.clickButtonBlock(button.tag);
    
}

//城市模型
- (void)setModel:(cityModel *)model {

    _model = model;
    
    if ([model.tag isEqualToString:@"100"]) {
        self.startingButton.contentText = model.csmc;
    } else {
        self.endingButton.contentText = model.csmc;
    }
    
}


- (void)setStartColor:(UIColor *)startColor {

    //NSLog(@"cell 变颜色");
    
    _startColor = startColor;
    self.startingButton.headlineColor = startColor;
}

- (void)setEndColor:(UIColor *)endColor {

    _endColor = endColor;
    self.endingButton.headlineColor = endColor;
}


@end
