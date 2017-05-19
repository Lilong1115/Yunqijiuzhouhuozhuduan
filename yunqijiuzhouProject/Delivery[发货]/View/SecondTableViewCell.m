//
//  SecondTableViewCell.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

//请选择样式cell
#import "SecondTableViewCell.h"
#import "DeliveryMenuModel.h"
#import "OilModel.h"

@interface SecondTableViewCell()

//标题
@property (nonatomic, weak) UILabel *title;
//请选择
@property (nonatomic, weak) UILabel *pleaseSelectLabel;
//go图标
@property (nonatomic, weak) UIImageView *goView;
//具体内容
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation SecondTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI {

    UILabel *title = [[UILabel alloc]init];
    title.text = @"货物类型";
    title.font = TextFont14;
    [self.contentView addSubview:title];
    self.title = title;
    
    UIImageView *goView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"go"]];
    [self.contentView addSubview:goView];
    self.goView = goView;
    
    UILabel *pleaseSelectLabel = [[UILabel alloc]init];
    pleaseSelectLabel.text = @"请选择";
    pleaseSelectLabel.font = TextFont14;
    [self.contentView addSubview:pleaseSelectLabel];
    self.pleaseSelectLabel = pleaseSelectLabel;
    
    UILabel *contentLabel = [[UILabel alloc]init];
    //contentLabel.text = @"请选择";
    contentLabel.numberOfLines = 0;
    contentLabel.font = TextFont14;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(8);
    }];
    [goView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).mas_offset(-8);
        make.size.mas_equalTo(CGSizeMake(32 / 2, 32 / 2));
    }];
    [pleaseSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(goView.mas_leading).mas_offset(-8);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(title.mas_trailing).mas_offset(8);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(200);
    }];
}

- (void)setMenuModel:(DeliveryMenuModel *)menuModel {

    _menuModel = menuModel;
    
    self.title.text = menuModel.title;
    
    if (menuModel.toMap == YES) {
        self.pleaseSelectLabel.hidden = YES;
        self.goView.image = [UIImage imageNamed:@"location"];
    } else {
        self.pleaseSelectLabel.hidden = NO;
        self.goView.image = [UIImage imageNamed:@"go"];
    }
    
}

- (void)setOilModel:(OilModel *)oilModel {

    _oilModel = oilModel;
    self.contentLabel.text = oilModel.hwlxmc;
}

- (void)setDate:(NSString *)date {

    _date = date;
    self.contentLabel.text = date;
}

- (void)setAddress:(NSString *)address {

    _address = address;
    self.contentLabel.text = address;
}

- (void)setDismissData:(NSString *)dismissData {
    
    _dismissData = dismissData;
    
    self.contentLabel.text = nil;
}

@end
