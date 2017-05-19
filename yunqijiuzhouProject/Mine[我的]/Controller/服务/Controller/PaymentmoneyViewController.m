//
//  PaymentmoneyViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/11.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "PaymentmoneyViewController.h"
#import "UserInfo.h"
#import "passwordBar.h"
#import "NSString+Hash.h"
#import "CallPhone.h"

@interface PaymentmoneyViewController ()<WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview


//密码
@property (nonatomic, strong) UITextField *passwordText;

//密码框
@property (nonatomic, weak) passwordBar *passwordBar;

//流水单号
@property (nonatomic, copy) NSString *serialNumber;

@end

@implementation PaymentmoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付";
    
    [self setUpWKWebView];
    
    [self creatPasswordText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeValue:)   name:@"changeValue" object:self.passwordText];
}

- (void)creatPasswordText {

    //密码
    self.passwordText = [[UITextField alloc]init];
    self.passwordText.delegate = self;
    self.passwordText.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //密码框
    self.passwordText.inputAccessoryView = [[passwordBar alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 110)];
    self.passwordBar = (passwordBar *)self.passwordText.inputAccessoryView;
    [self.view addSubview:self.passwordText];
    
    __weak PaymentmoneyViewController *weakSelf = self;
    //完成回调
    self.passwordBar.completeBlock = ^(){
        
        [weakSelf.view endEditing:YES];
        
        if (weakSelf.passwordText.text.length == 6) {
            
            [weakSelf.view endEditing:YES];
            JCAlertController *alert = [[JCAlertController alloc]initWithTitle:@"提示" message:@"确认支付?" type:JCAlertTypeNormal];
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
                
                [weakSelf complete];
            }];
            
            [weakSelf jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        }
        
        self.passwordBar.password = @"";
        self.passwordText.text = @"";
        
    };
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    //NSLog(@"%@", textField.text);
    
    //self.passwordBar.password = textField.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:textField];
}

//确认支付
- (void)complete {
    
    if (self.serialNumber.length > 0) {
        //线下
        [self ConfirmPaymentWithUrlStr:OfflinePay_URL];
        
    } else {
        //线上
        [self ConfirmPaymentWithUrlStr:OnlinePay_URL];
    }
    
}

//线上支付
- (void)ConfirmPaymentWithUrlStr:(NSString *)urlStr {

    NSDictionary *dict;
    
    if ([urlStr isEqualToString:OfflinePay_URL]) {
        
        dict = @{
                 @"waterid": self.serialNumber,
                 @"fhdxtbh": self.jsonDict[@"fhdxtbh"],
                 @"fhdbh": self.jsonDict[@"fhdbh"],
                 @"atype": self.jsonDict[@"sfhs"],
                 //@"paynum": self.jsonDict[@"yfje"],
                 @"yhbh": GetUuid
                 };
        
    } else {
        
        NSString *atype;
        if ([self.jsonDict[@"sfhs"] isEqualToString:@"0"]) {
            atype = @"1";
        } else {
            atype = @"0";
        }
        
        dict = @{
                   @"zfmm": [self.passwordText.text md5String],
                   @"fhdxtbh": self.jsonDict[@"fhdxtbh"],
                   @"fhdbh": self.jsonDict[@"fhdbh"],
                   @"atype": atype,
                   @"paynum": self.jsonDict[@"yfje"],
                   @"yhbh": GetUuid
                   };
    }
    
    /*
     线下的
     map.put("fhdxtbh", order.getFhdxtbh());
     map.put("fhdbh", order.getFhdbh());
     map.put("atype", order.getSfhs());
     //                            map.put("paynum", order.getYfje());
     map.put("waterid", mEtSerialNum.getText().toString());
     map.put("yhbh", PreferencesUtils.getString("uuid"));
     */
    
    /*
     map.put("zfmm", AppUtils.MD5Encryption(data.getStringExtra("pwd")));
     map.put("fhdxtbh", order.getFhdxtbh());
     map.put("fhdbh", order.getFhdbh());
     if (order.getSfhs().equals("0")) {
     map.put("atype", 1);
     } else {
     map.put("atype", 0);
     }
     //                map.put("atype", order.getSfhs());
     map.put("paynum", order.getYfje());
     map.put("yhbh", PreferencesUtils.getString("uuid"));
     */
    
    NSString *json = [NSString ObjectTojsonString:dict];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{@"basic": jsonBase64};
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:urlStr andParameters:parameters andSuccessBlock:^(id result) {
        
        [LLGHUD showInfoWithStatus:result[@"msg"]];
        
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

-(void)changeValue:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    //要实现的监听方法操作
    
    //NSLog(@"%@", textField.text);
    
    self.passwordBar.password = textField.text;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// viewWillAppear和viewWillDisappear对setWebViewDelegate处理，不处理会导致内存泄漏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.bridge) {
        [self.bridge setWebViewDelegate:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bridge setWebViewDelegate:nil];
}

- (void)dealloc
{
    NSLog(@"dealloc==dealloc==");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpWKWebView {
    self.wkWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    self.wkWebView.scrollView.bounces = NO;
    //确认支付
    [_bridge registerHandler:@"MoneyQR" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //[self.view endEditing:YES];
        
        NSString *str = (NSString *)data;
        
        if (str.length > 0) {
            self.serialNumber = str;
            JCAlertController *alert = [[JCAlertController alloc]initWithTitle:@"提示" message:@"确认支付?" type:JCAlertTypeNormal];
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
                
                [self complete];
            }];
            [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        } else {
            self.serialNumber = @"";
            [self.passwordText becomeFirstResponder];
        }
        
    }];
    
    //余额不足
    [_bridge registerHandler:@"Nomoney" handler:^(id data, WVJBResponseCallback responseCallback) {
        [LLGHUD showErrorWithStatus:@"钱包余额不足"];
    }];
    
    //流水号为空
    [_bridge registerHandler:@"Noempty" handler:^(id data, WVJBResponseCallback responseCallback) {
        [LLGHUD showErrorWithStatus:@"请输入流水号"];
    }];
    
    //电话
    [_bridge registerHandler:@"call" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *str = (NSString *)data;
        [CallPhone callPhoneWithPhoneStr:str];
    }];
    
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    //NSString *str = [NSString ObjectTojsonString:self.jsonDict];
    
//    NSLog(@"%@", [NSString stringWithFormat:@"%@?json=%@", Paymentmoney_URL, str]);
    
    //NSString *string = [NSString removeBlankSpace:str];
    
//"fhdbh":fhdbh,"yfje":yfje,"fhdxtbh":fhdxtbh,"sfhs":sfhs
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?fhdbh=%@&yfje=%@&fhdxtbh=%@&sfhs=%@&uuid=%@", Paymentmoney_URL, self.jsonDict[@"fhdbh"], self.jsonDict[@"yfje"], self.jsonDict[@"fhdxtbh"], self.jsonDict[@"sfhs"], GetUuid]]]];
    
    
}




//textfield代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location >= 6)
        
        return NO;
    
    return YES;
    
}

@end
