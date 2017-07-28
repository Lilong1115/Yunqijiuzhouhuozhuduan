//
//  HomeViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "HomeViewController.h"
#import <WebKit/WebKit.h>
#import "DeliveryTableViewController.h"
#import "UserInfo.h"
#import "RealTimeInformationViewController.h"
#import "CallPhone.h"
#import "SearchResourcesViewController.h"

@interface HomeViewController ()<WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

//客服电话
@property (nonatomic, weak) UIButton *phoneButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setUpWKWebView];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"helper"] forState:UIControlStateNormal];
    phoneButton.frame = CGRectMake(ScreenW - 60 - 10, ScreenH / 2 - 30, 60, 60);
    [self.view addSubview:phoneButton];
    [phoneButton addTarget:self action:@selector(toPhone) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    
}

//客服电话
- (void)toPhone {

    [CallPhone callPhoneWithPhoneStr:ServicePhone];
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
    
    self.wkWebView.scrollView.delegate = self;
    self.wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadExamplePage:self.wkWebView];
//        [self.wkWebView.scrollView.mj_header endRefreshing];
    }];
    
    //我要发货
    [_bridge registerHandler:@"mydelivery" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        if ([UserInfo account]) {
            
            //我要发货
            DeliveryTableViewController *toDeliveryVC = [[DeliveryTableViewController alloc]init];
            
            toDeliveryVC.navigationItem.title = @"我要发货";
            //toDeliveryVC.dataDict = dict;
            [self.navigationController pushViewController:toDeliveryVC animated:YES];
            
        } else {
        
            JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"请先登录" type:JCAlertTypeNormal];
            
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
                
                // - 获取storyboard文件
                UIStoryboard *sBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                
                // - 实例化文件中的初始化控制器[或者根据标记实例化控制器]
                // 多态,父类的指针指向之类的对象!
                UINavigationController *loginVC = [sBoard instantiateInitialViewController];
                
                [self presentViewController:loginVC animated:YES completion:nil];
            }];
            
            [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
            
            
        }
        
    }];
    
    //实时资讯
    [_bridge registerHandler:@"LinkURL" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *urlStr = (NSString *)data;
        
        RealTimeInformationViewController *vc = [[RealTimeInformationViewController alloc]init];
        
        vc.urlStr = urlStr;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //电话
    [_bridge registerHandler:@"Telephone" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *phone = (NSString *)data;
        
        [CallPhone callPhoneWithPhoneStr:phone];
        
    }];
    
    //更多油品资源
    [_bridge registerHandler:@"MoreOils" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        SearchResourcesViewController *vc = [[SearchResourcesViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [self loadExamplePage:self.wkWebView];
}




// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Home_URL]]];
    
    //@"http://192.168.100.169:8080/antu/MovewebhomeCon.con/index"
    
}

LoadWebViewHUD

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    self.phoneButton.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    self.phoneButton.hidden = NO;
}

/*
 mydelivery 我要发货
 */

@end
