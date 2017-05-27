//
//  AddCircleViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/24.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "AddCircleViewController.h"
#import "UserInfo.h"

@interface AddCircleViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation AddCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    NSLog(@"dealloc==dealloc==");
}

- (void)setUpWKWebView {
    self.wkWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64 - 10)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    // 注册一下
    //发布
    [_bridge registerHandler:@"ReleaseSuccess" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *str = (NSString *)data;
        
        if ([str isEqualToString:@"yes"]) {
            [LLGHUD showSuccessWithStatus:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [LLGHUD showErrorWithStatus:@"发布失败"];
        }
        
    }];
    
    //加载
    [_bridge registerHandler:@"Circlestart" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [SVProgressHUD showWithStatus:@"正在发布..."];
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AddCircle_URL, GetUuid]]]];
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

@end
