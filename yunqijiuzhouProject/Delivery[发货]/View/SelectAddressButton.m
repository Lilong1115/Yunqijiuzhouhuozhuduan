//
//  SelectAddressButton.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

//出发地 目的地 按钮
#import "SelectAddressButton.h"

@interface SelectAddressButton()

//标题
@property (nonatomic, weak) UILabel *title;
//内容
@property (nonatomic, weak) UILabel *content;

@end

@implementation SelectAddressButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"出发地:";
    title.font = TextFont14;
    [self addSubview:title];
    self.title = title;
    
    //内容
    UILabel *content = [[UILabel alloc]init];
    //content.text = @"北京市";
    content.font = TextFont14;
    [self addSubview:content];
    self.content = content;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self).mas_offset(8);
    }];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(title.mas_trailing);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)setHeadline:(NSString *)headline {

    _headline = headline;
    
    self.title.text = headline;
}


- (void)setContentText:(NSString *)contentText {

    _contentText = contentText;
    
    self.content.text = contentText;
}

- (void)setHeadlineColor:(UIColor *)headlineColor {

    //NSLog(@"按钮 变颜色");
    
    _headlineColor = headlineColor;
    self.title.textColor = headlineColor;

}

@end
