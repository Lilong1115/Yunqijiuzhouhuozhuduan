//
//  PaymentListViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/11.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "PaymentListViewController.h"
#import "UserInfo.h"
#import "PaymentViewController.h"

@interface PaymentListViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation PaymentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付运费";
    
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
    
    self.wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadExamplePage:self.wkWebView];
        [self.wkWebView.scrollView.mj_header endRefreshing];
    }];
    
    //点击
    [_bridge registerHandler:@"Information" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *orderNum = (NSString *)data;
        
        PaymentViewController *vc = [[PaymentViewController alloc]init];
        vc.orderNum = orderNum;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?uuid=%@", PaymentList_URL, GetUuid]]]];
    
}

@end
