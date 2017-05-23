//
//  LoginViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfo.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.username.layer.cornerRadius = 5;
    self.username.layer.masksToBounds = YES;
    self.username.layer.borderWidth = 1;
    self.username.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.password.layer.cornerRadius = 5;
    self.password.layer.masksToBounds = YES;
    self.password.layer.borderWidth = 1;
    self.password.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    
    self.username.delegate = self;
    self.password.delegate = self;
    
    //提示消失时通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedResponder:) name:SVProgressHUDDidDisappearNotification object:nil];
}

//登录
- (IBAction)clickLoginButton:(UIButton *)sender {
  
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在登陆..."];
    
    if (self.username.text.length == 0 && self.password.text.length == 0) {
        
        [LLGHUD showInfoWithStatus:@"请输入手机号和密码"];
        
    } else if (self.username.text.length == 0 && self.password.text.length != 0) {
        [LLGHUD showInfoWithStatus:@"请输入手机号"];
    } else if (self.username.text.length != 0 && self.password.text.length == 0) {
        [LLGHUD showInfoWithStatus:@"请输入密码"];
    } else {
        
        [UserInfo loginWithPhone:self.username.text password:self.password.text];
        
    }

}


//提示信息后响应
- (void)selectedResponder:(NSNotification *)noti {
    
    NSString *hudStr = noti.userInfo[SVProgressHUDStatusUserInfoKey];
    
    if ([hudStr isEqualToString:@"请输入手机号和密码"]) {
        [self.username becomeFirstResponder];
    } else if ([hudStr isEqualToString:@"请输入手机号"]) {
        [self.username becomeFirstResponder];
    } else if ([hudStr isEqualToString:@"请输入密码"]) {
        [self.password becomeFirstResponder];
    } else if ([hudStr isEqualToString:@"登陆成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([hudStr isEqualToString:@"手机号或密码错误"]) {
        [self.username becomeFirstResponder];
    }
    
}


//textfield代理方法
//开始编辑时
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor redColor].CGColor;
}

//结束编辑时
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
