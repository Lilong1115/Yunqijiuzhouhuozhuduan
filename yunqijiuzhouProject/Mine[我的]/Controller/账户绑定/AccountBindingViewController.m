//
//  AccountBindingViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/6.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "AccountBindingViewController.h"
#import "BindingViewController.h"
#import "WithdrawalViewController.h"

@interface AccountBindingViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation AccountBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账户余额";
    
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
    
    //绑定银行卡
    [_bridge registerHandler:@"Binding" handler:^(id data, WVJBResponseCallback responseCallback) {
 
        BindingViewController *vc = [[BindingViewController alloc]init];
        vc.ywlx = self.ywlx;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //提现
    [_bridge registerHandler:@"Reflect" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        WithdrawalViewController *vc = [[WithdrawalViewController alloc]init];
        
        if (self.gzzhMoney.length > 0) {
            vc.gzzhMoney = self.gzzhMoney;
        }
        
        if (self.grzhMoney.length > 0) {
            vc.grzhMoney = self.grzhMoney;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

@end
