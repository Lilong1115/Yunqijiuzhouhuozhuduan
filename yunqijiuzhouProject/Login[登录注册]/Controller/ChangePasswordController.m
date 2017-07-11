//
//  ChangePasswordController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/6/29.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "ChangePasswordController.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "NSString+Hash.h"

@interface ChangePasswordController ()

@property (nonatomic, weak) UITextField *phoneText;
@property (nonatomic, weak) UITextField *neText;
@property (nonatomic, weak) UITextField *againText;
@property (nonatomic, weak) UITextField *codeText;
@property (nonatomic, weak) UIButton *codeButton;
@property (nonatomic, weak) UIButton *submitButton;


@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码";
    [self setupUI];
    
}

- (void)setupUI {

    UITextField *phoneText = [self creatTextWithPlaceholder:@"请输入手机号码"];
    phoneText.frame = CGRectMake(10, 20, ScreenW - 10 * 2, 40);
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneText];
    self.phoneText = phoneText;
    
    if (self.phone.length != 0) {
        phoneText.text = self.phone;
        phoneText.userInteractionEnabled = NO;
    }
    
    UITextField *newText = [self creatTextWithPlaceholder:@"请输入您的新密码"];
    newText.frame = CGRectMake(10, 20 * 2 + 40, ScreenW - 10 * 2, 40);
    newText.keyboardType = UIKeyboardTypeASCIICapable;
    newText.secureTextEntry = YES;
    [self.view addSubview:newText];
    self.neText = newText;
    
    UITextField *againText = [self creatTextWithPlaceholder:@"请再次输入您的新密码"];
    againText.frame = CGRectMake(10, 20 * 3 + 40 * 2, ScreenW - 10 * 2, 40);
    againText.keyboardType = UIKeyboardTypeASCIICapable;
    againText.secureTextEntry = YES;
    [self.view addSubview:againText];
    self.againText = againText;
    
    UITextField *codeText = [self creatTextWithPlaceholder:@"请输入验证码"];
    codeText.frame = CGRectMake(10, 20 * 4 + 40 * 3, ScreenW - 10 * 3 - 150, 40);
    codeText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:codeText];
    self.codeText = codeText;
    
    UIButton *codeButton = [self creatButtonWithTitle:@"获取验证码"];
    codeButton.frame = CGRectMake(ScreenW - 10 - 150, 20 * 4 + 40 * 3, 150, 40);
    [codeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeButton];
    self.codeButton = codeButton;
    
    UIButton *submitButton = [self creatButtonWithTitle:@"确认修改"];
    submitButton.frame = CGRectMake(10, 20 * 5 + 40 * 4, ScreenW - 10 * 2, 40);
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    self.submitButton = submitButton;
    
}


//确认修改
- (void)submit:(UIButton *)sender {

    if (self.phoneText.text.length == 0) {
        [LLGHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    if (self.neText.text.length == 0) {
        [LLGHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (self.againText.text.length == 0) {
        [LLGHUD showErrorWithStatus:@"请再次输入新密码"];
        return;
    }
    if (self.codeText.text.length == 0) {
        [LLGHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (![self.neText.text isEqualToString:self.againText.text]) {
        [LLGHUD showErrorWithStatus:@"两次输入密码必须相同"];
        return;
    }
    NSDictionary *dict = @{
                           @"phone": self.phoneText.text,
                           @"password": [self.neText.text md5String],
                           @"random": self.codeText.text
                           };
    
    NSString *json = [NSString ObjectTojsonString:dict];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{@"basic": jsonBase64};
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:ChangePassword_URL andParameters:parameters andSuccessBlock:^(id result) {
        
        if ([result[@"data"] isEqualToString:@"1000"]) {
            //主线程发送通知,更新界面
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [LLGHUD showSuccessWithStatus:@"修改成功"];
                [UserInfo logout];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [LLGHUD showErrorWithStatus:result[@"msg"]];
            
        }
        
        
    } andFailBlock:^(NSError *error) {
        [LLGHUD showErrorWithStatus:@"网络连接错误"];
    }];
    
}


- (void)getCode:(UIButton *)sender {

    if (self.phoneText.text.length == 0) {
        [LLGHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"phone": self.phoneText.text
                           };
    
    NSString *json = [NSString ObjectTojsonString:dict];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{@"basic": jsonBase64};
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:GetCode_URL andParameters:parameters andSuccessBlock:^(id result) {

        if ([result[@"data"] isEqualToString:@"1000"]) {
            //主线程发送通知,更新界面
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self startTime];
                
            }];
        } else {
            [LLGHUD showErrorWithStatus:result[@"msg"]];
            
        }
        
        
    } andFailBlock:^(NSError *error) {
        [LLGHUD showErrorWithStatus:@"网络连接错误"];
    }];
    
    
    
}

- (void)startTime {

    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                //设置不可点击
                self.codeButton.userInteractionEnabled = YES;
                self.codeButton.backgroundColor = [UIColor redColor];
                
            });
        }else{
            //            int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                //设置可点击
                self.codeButton.userInteractionEnabled = NO;
                self.codeButton.backgroundColor = [UIColor lightGrayColor];
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

- (UIButton *)creatButtonWithTitle:(NSString *)title {

    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    return button;
}


- (UITextField *)creatTextWithPlaceholder:(NSString *)placeholder {

    UITextField *text = [[UITextField alloc]init];
    text.placeholder = placeholder;
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.layer.cornerRadius = 5;
    text.layer.masksToBounds = YES;
    text.layer.borderColor = [UIColor grayColor].CGColor;
    text.layer.borderWidth = 1;
    return text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
