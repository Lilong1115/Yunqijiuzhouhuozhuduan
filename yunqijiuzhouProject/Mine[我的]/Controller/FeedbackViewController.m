//
//  FeedbackViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/19.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LLGTextView.h"
#import "UserInfo.h"

@interface FeedbackViewController ()
//联系方式
@property (weak, nonatomic) IBOutlet UITextField *contactText;
//意见
@property (weak, nonatomic) IBOutlet LLGTextView *opinionText;
//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contactText becomeFirstResponder];
    
    self.opinionText.placeholder = @"请输入您的宝贵意见或建议,我们将尽快回复您!";
    self.opinionText.placeholderColor = [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:0.4];
    
    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = YES;
    
    //提示消失时通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedResponder:) name:SVProgressHUDDidDisappearNotification object:nil];
}

//提交按钮
- (IBAction)clickSubmitButton:(UIButton *)sender {
    /*
    "yhly":2,   -- 2货主端  1车主端
    "yjnr":"1", -- 意见内容
    "yjbt":"1", -- 联系方式
    "uuid":"7373161f817b4d7db6938154874400b2" -- 用户登录过传uuid,没有登录则不需上传
    */
    [self.view endEditing:YES];
    
    if (self.contactText.text.length == 0 && self.opinionText.text.length == 0) {
        
        [LLGHUD showInfoWithStatus:@"请输入联系方式和反馈意见"];
        
    } else if (self.contactText.text.length == 0 && self.opinionText.text.length != 0) {
        [LLGHUD showInfoWithStatus:@"请输入联系方式"];
    } else if (self.contactText.text.length != 0 && self.opinionText.text.length == 0) {
        [LLGHUD showInfoWithStatus:@"请输入反馈意见"];
    } else {
        
        JCAlertController *alert = [[JCAlertController alloc]initWithTitle:@"提示" message:@"意见提交?" type:JCAlertTypeNormal];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
            
            [self requestData];
            
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
    }
    
}

//提交数据
- (void)requestData {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"yhly"] = @"1";
    dict[@"yjbt"] = self.contactText.text;
    dict[@"yjnr"] = self.opinionText.text;
    
    if ([UserInfo account]) {
        dict[@"uuid"] = [UserInfo account].uuid;
    }
    
    NSString *json = [NSString ObjectTojsonString:dict.copy];
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{
                                 @"basic": jsonBase64
                                 };
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:SubmitOption_URL andParameters:parameters andSuccessBlock:^(id result) {
        
        if ([result[@"msg"] isEqualToString:@"添加成功"]) {
            
            [LLGHUD showSuccessWithStatus:@"感谢您的建议,我们会尽快回复您!"];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [LLGHUD showErrorWithStatus:@"网络异常"];
        }
        
    } andFailBlock:^(NSError *error) {
        
        
        
    }];
    
    
}

//提示信息后响应
- (void)selectedResponder:(NSNotification *)noti {
    
    NSString *hudStr = noti.userInfo[SVProgressHUDStatusUserInfoKey];
    
    if ([hudStr isEqualToString:@"请输入联系方式和反馈意见"]) {
        [self.contactText becomeFirstResponder];
    } else if ([hudStr isEqualToString:@"请输入联系方式"]) {
        [self.contactText becomeFirstResponder];
    } else if ([hudStr isEqualToString:@"请输入反馈意见"]) {
        [self.opinionText becomeFirstResponder];
    } else if ([hudStr isEqualToString:@"网络异常"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
