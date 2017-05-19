//
//  passwordBar.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "passwordBar.h"

@interface passwordBar()

//密码框
@property (nonatomic, strong) NSArray *passwordArray;

@end

@implementation passwordBar

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {

    CGFloat margin = 20;
    CGFloat width = (ScreenW - margin * 2) / 6;
    CGFloat height = width;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImageView *button = [[UIImageView alloc]init];
        button.userInteractionEnabled = NO;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"password"] forState:UIControlStateSelected];
        //button.image = [UIImage imageWithColor:[UIColor whiteColor]];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).mas_offset(-margin);
            make.leading.mas_equalTo(self).mas_offset(margin + i * width);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width);
        }];
        
        [arrayM addObject:button];
    }
    
    self.passwordArray = arrayM.copy;
    
    //完成按钮
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:completeButton];
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).mas_offset(-8);
        make.top.mas_equalTo(self);
    }];
    [completeButton addTarget:self action:@selector(dissmissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
}

//完成
- (void)dissmissKeyboard {

    if (self.completeBlock != nil) {
        self.completeBlock();
    }
    
//    [self.passwordArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
//        button.selected = NO;
//        //button.image = [UIImage imageWithColor:[UIColor whiteColor]];
//    }];
}

- (void)setPassword:(NSString *)password {

    _password = password;
    
    //NSLog(@"%@", password);
    
    for (int i = 0; i < password.length; i++) {
        UIButton *button = self.passwordArray[i];
        button.selected = YES;
        //button.image = [UIImage imageNamed:@"password"];
    }
    
    for (int i = 0; i < self.passwordArray.count - password.length; i++) {
        
        UIButton *button = self.passwordArray[self.passwordArray.count - i - 1];
        button.selected = NO;
        
    }
    
}

@end
