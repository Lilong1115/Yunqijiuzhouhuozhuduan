//
//  ThirdTableViewCell.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

//可编辑的cell
#import "ThirdTableViewCell.h"
#import "DeliveryMenuModel.h"

@interface ThirdTableViewCell()<UITextFieldDelegate>
//标题
@property (nonatomic, weak) UILabel *title;
//单位
@property (nonatomic, weak) UILabel *unitLabel;
//含税选项
@property (nonatomic, weak) UIButton *tickButton;
//含税
@property (nonatomic, weak) UILabel *taxLabel;
//输入区域
@property (nonatomic, weak) UITextField *contentText;

@end

@implementation ThirdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {

    UILabel *title = [[UILabel alloc]init];
    title.text = @"货物重量";
    title.font = TextFont14;
    [self.contentView addSubview:title];
    self.title = title;
    
    UITextField *contentText = [[UITextField alloc]init];
    contentText.tintColor = [UIColor redColor];
    contentText.font = TextFont14;
    [self.contentView addSubview:contentText];
    self.contentText = contentText;
    
    contentText.delegate = self;
    
    UILabel *unitLabel = [[UILabel alloc]init];
    unitLabel.text = @"吨";
    unitLabel.font = TextFont14;
    [self.contentView addSubview:unitLabel];
    self.unitLabel = unitLabel;
    
    UIButton *tickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tickButton addTarget:self action:@selector(clickTickButton) forControlEvents:UIControlEventTouchUpInside];
    [tickButton setBackgroundImage:[UIImage imageNamed:@"tick_normal"] forState:UIControlStateNormal];
    [tickButton setBackgroundImage:[UIImage imageNamed:@"tick_selected"] forState:UIControlStateSelected];
    //tickButton.layer.borderWidth = 2;
    //tickButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:tickButton];
    self.tickButton = tickButton;
    
    UILabel *taxLabel = [[UILabel alloc]init];
    taxLabel.text = @"含税";
    taxLabel.font = TextFont14;
    [self.contentView addSubview:taxLabel];
    self.taxLabel = taxLabel;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).mas_offset(8);
    }];
    [contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(title.mas_trailing).mas_offset(8);
        make.width.mas_equalTo(300);
        //make.trailing.mas_equalTo(self.contentView).mas_offset(-8);
    }];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).mas_offset(-8);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [tickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).mas_offset(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [taxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(tickButton.mas_leading).mas_offset(-8);
    }];
}


- (void)setMenuModel:(DeliveryMenuModel *)menuModel {

    _menuModel = menuModel;
    
    self.title.text = menuModel.title;
    self.unitLabel.hidden = !menuModel.haveUnit;
    self.taxLabel.hidden = !menuModel.haveTax;
    self.tickButton.hidden = !menuModel.haveTax;

    if (menuModel.keyboard == YES) {
        self.contentText.keyboardType = UIKeyboardTypeDecimalPad;
    } else {
        self.contentText.keyboardType = UIKeyboardTypeDefault;
    }
    
    if ([menuModel.title isEqualToString:@" "]) {
        self.contentText.placeholder = @"请输入备注";
    } else {
        self.contentText.placeholder = @"";
    }
    
    if ([menuModel.title isEqualToString:@"预付定金(%)"]) {
        self.contentText.tag = 1;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.keyboardType == UIKeyboardTypeDecimalPad) {
        
        if ([string isEqualToString:@"0"] && [textField.text isEqualToString:@"0"]) {
            return NO;
        }
        
        if ([string floatValue] > 0 && [textField.text isEqualToString:@"0"]) {
            return NO;
        }
        
        
        if (textField.tag == 1) {
            if ([[NSString stringWithFormat:@"%@%@", textField.text, string] floatValue] > 100) {
                return NO;
            }
        }
        
        
    }
    
    return YES;
}

//含不含税
- (void)clickTickButton {

    self.tickButton.selected = !self.tickButton.selected;
    
    if (self.tickButton.selected == NO) {
        self.tickBlock(@"0");
    } else {
        self.tickBlock(@"1");
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.contentBlock(textField.text);
}

- (void)setDismissData:(NSString *)dismissData {

    _dismissData = dismissData;
    
    //NSLog(@"123");
    
    self.tickButton.selected = NO;
    self.contentText.text = nil;
}

- (void)setData:(NSString *)data {

    _data = data;
    self.contentText.text = data;
}


@end
