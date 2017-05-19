//
//  ModifyPaymentPasswordController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/10.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//
//修改支付密码
#import "ModifyPaymentPasswordController.h"
#import "UserInfo.h"

@interface ModifyPaymentPasswordController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation ModifyPaymentPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navTitle;
    
    [self setUpWKWebView];
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
}

- (void)setUpWKWebView {
    self.wkWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    //下一步
    [_bridge registerHandler:@"Password" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *str = (NSString *)data;
        
        if (str.length == 0) {
            [LLGHUD showErrorWithStatus:@"密码错误"];
        }
        
    }];
    
    //下一步 验证码
    [_bridge registerHandler:@"Verification" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *str = (NSString *)data;
        
        if (str.length == 0) {
            [LLGHUD showErrorWithStatus:@"验证码不正确"];
        }
        
    }];
    
    //修改密码
    [_bridge registerHandler:@"Success" handler:^(id data, WVJBResponseCallback responseCallback) {
        //Atypism
        NSString *str = (NSString *)data;
        
        if ([str isEqualToString:@"true"]) {
            [LLGHUD showSuccessWithStatus:@"成功修改密码"];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([str isEqualToString:@"Atypism"]) {
        
            [LLGHUD showErrorWithStatus:@"两次输入密码不相同"];
        } else {
            [LLGHUD showErrorWithStatus:@"修改密码失败"];
        }
        
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?uuid=%@&yhsjh=%@&type=1", self.urlStr, GetUuid, [UserInfo account].phone]]]];
    
}

@end
