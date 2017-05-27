//
//  RegisterViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/5.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
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
    
    self.wkWebView.scrollView.bounces = NO;
    
    //状态码
    [_bridge registerHandler:@"Satatzt" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *str = (NSString *)data;
        
        NSLog(@"%@", str);
        
        //成功
        if ([str isEqualToString:@"cg"]) {
            
            [LLGHUD showSuccessWithStatus:@"提交注册成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            //失败
        } else if ([str isEqualToString:@"sb"]) {
            [LLGHUD showErrorWithStatus:@"提交注册失败"];
            //手机号格式不正确
        } else if ([str isEqualToString:@"sjhgsbzq "]) {
            [LLGHUD showErrorWithStatus:@"手机号格式不正确"];
            //手机号已存在
        } else if ([str isEqualToString:@"sjhcz"]) {
            
            [LLGHUD showErrorWithStatus:@"手机号已存在"];
        }
    }];
    
    //加载
    [_bridge registerHandler:@"Circlestart" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [SVProgressHUD showWithStatus:@"正在注册..."];
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Register_URL]]];
    
    
}
@end
