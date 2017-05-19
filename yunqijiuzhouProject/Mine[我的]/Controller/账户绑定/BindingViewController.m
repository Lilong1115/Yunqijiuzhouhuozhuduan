//
//  BindingViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/8.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "BindingViewController.h"
#import "UserInfo.h"

@interface BindingViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定银行卡";
    
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
    
    //提交
    [_bridge registerHandler:@"State" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *str = (NSString *)data;
        
        //NSLog(@"%@", str);
        
        if ([str isEqualToString:@"true"]) {
            [LLGHUD showSuccessWithStatus:@"绑定成功"];
            
            XBAccount *account = [UserInfo account];
            
            if ([self.ywlx isEqualToString:@"0"]) {
                account.gzzh = @"1";
                
            } else {
                account.szzh = @"1";
            }
            
            [UserInfo saveAccount:account];
            
            NSArray *pushVCAry=[self.navigationController viewControllers];
            
            //下面的pushVCAry.count-3 是让我回到视图1中去
            
            UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
            
            [self.navigationController popToViewController:popVC animated:YES];
        } else {
            [LLGHUD showErrorWithStatus:@"绑定失败"];
        }
        
    }];
    
    [self loadExamplePage:self.wkWebView];
}


// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?uuid=%@&yhsjh=%@&ywlx=%@", BindingAccount_URL, GetUuid, [UserInfo account].phone, self.ywlx]]]];
    
}

@end
