//
//  PaymentViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/11.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentmoneyViewController.h"
#import "UserInfo.h"

@interface PaymentViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation PaymentViewController

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
    
    //支付
    [_bridge registerHandler:@"Paymentmoney" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSLog(@"%@", data);
        
        NSDictionary *dict = (NSDictionary *)data;
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        //[dictM setValue:GetUuid forKey:@"uuid"];
        //responseCallback(dictM);
        
        PaymentmoneyViewController *vc = [[PaymentmoneyViewController alloc]init];
        vc.jsonDict = dictM.copy;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?orderNum=%@&page=1", SendCarPlanInfo_URL, self.orderNum]]]];
    
}


@end
