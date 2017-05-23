//
//  OrderViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/26.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "OrderViewController.h"
#import "XSJScrollrecommendationView.h"
#import "UserInfo.h"
#import "CallPhone.h"
#import "OrderContentViewController.h"
#import "DeliveryTableViewController.h"
#import "PaymentListViewController.h"

@interface OrderViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@property (nonatomic, weak) XSJScrollrecommendationView *scrollView;

//标记选中页面
@property (nonatomic, assign) NSInteger tag;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XSJScrollrecommendationView *scrollView = [[XSJScrollrecommendationView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    
    self.tag = 1000;
    
    __weak __typeof(self)weakSelf = self;
    //选择回调
    scrollView.clickTypeBlock = ^(selectedType tag){
        
        weakSelf.tag = tag;
        
        switch (tag) {
            case selectedTypeTodayRecommendation:
                [weakSelf loadExamplePage:weakSelf.wkWebView urlStr:YBJOrderManagement_URL];
                break;
            case selectedTypeOfflineRecommendation:
                [weakSelf loadExamplePage:weakSelf.wkWebView urlStr:YQYOrderManagement_URL];
                break;
            case selectedTypeOnlineRecommendation:
                [weakSelf loadExamplePage:weakSelf.wkWebView urlStr:YWCOrderManagement_URL];
                break;
        }
    };
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self setUpWKWebView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pay:(UIBarButtonItem *)sender {
    
    PaymentListViewController *vc = [[PaymentListViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    self.wkWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, ScreenW, ScreenH - 44 - 49 - 64)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    self.wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        switch (self.tag) {
            case selectedTypeTodayRecommendation:
                [self loadExamplePage:self.wkWebView urlStr:YBJOrderManagement_URL];
                break;
            case selectedTypeOfflineRecommendation:
                [self loadExamplePage:self.wkWebView urlStr:YQYOrderManagement_URL];
                break;
            case selectedTypeOnlineRecommendation:
                [self loadExamplePage:self.wkWebView urlStr:YWCOrderManagement_URL];
                break;
        }
        
        
        [self.wkWebView.scrollView.mj_header endRefreshing];
    }];
    
    // 注册一下
    
    __weak __typeof(self)weakSelf = self;
    // js调用oc
    //电话
    [_bridge registerHandler:@"call" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *phoneStr = (NSString *)data;
        [CallPhone callPhoneWithPhoneStr:phoneStr];
        
    }];
    //详情页
    [_bridge registerHandler:@"orderDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *order = (NSString *)data;
        
        NSString *orderStr = [NSString stringWithFormat:@"%@?fhdxtbh=%@", OrderDetails_URL, order];
  
        OrderContentViewController *vc = [[OrderContentViewController alloc]init];
        vc.orderStr = orderStr;
        //vc.orderNum = order;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    //取消发货
    [_bridge registerHandler:@"cancelOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *order = (NSDictionary *)data;
        
        //NSLog(@"%@", order);
        
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确认取消?" type:JCAlertTypeNormal];
        
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
            
            [weakSelf requestOrderStr:order urlStr:CancelOrder_URL successBlock:^(id result) {
                
                if ([result[@"msg"] isEqualToString:@"成功"]) {
                    
                    //NSLog(@"登陆成功");
                    
                    [LLGHUD showSuccessWithStatus:@"取消成功"];
                    
                    [weakSelf loadExamplePage:weakSelf.wkWebView urlStr:YBJOrderManagement_URL];
                    
                } else {
                    
                    [LLGHUD showErrorWithStatus:@"取消失败"];
                }
            } failBlock:^(NSError *error) {
                
                [LLGHUD showErrorWithStatus:@"取消失败"];
            }];
            
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }];
    //确认签约
    [_bridge registerHandler:@"signOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSDictionary *order = (NSDictionary *)data;
        
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确认签约?" type:JCAlertTypeNormal];
        
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
            [weakSelf requestOrderStr:order urlStr:ConfirmOrder_URL successBlock:^(id result) {
                
                if ([result[@"msg"] isEqualToString:@"成功"]) {
                    
                    //NSLog(@"登陆成功");
                    
                    [LLGHUD showSuccessWithStatus:@"签约成功"];
                    
                    [weakSelf loadExamplePage:weakSelf.wkWebView urlStr:YBJOrderManagement_URL];
                    
                } else {
                    
                    [LLGHUD showErrorWithStatus:@"签约失败"];
                }
            } failBlock:^(NSError *error) {
                
                [LLGHUD showErrorWithStatus:@"签约失败"];
            }];
            
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }];
    //完成订单
    [_bridge registerHandler:@"finishOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            
            NSDictionary *order = (NSDictionary *)data;
            
            JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确认完成?" type:JCAlertTypeNormal];
            
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
                [weakSelf requestOrderStr:order urlStr:CompletedOrder_URL successBlock:^(id result) {
                    
                    NSLog(@"result %@", result);
                    
                    if ([result[@"msg"] isEqualToString:@"成功"]) {
                        
                        //NSLog(@"登陆成功");
                        
                        [LLGHUD showSuccessWithStatus:@"订单完成"];
                        
                        [weakSelf loadExamplePage:weakSelf.wkWebView urlStr:YQYOrderManagement_URL];
                        
                    } else {
                        
                        [LLGHUD showErrorWithStatus:@"完成失败"];
                    }
                } failBlock:^(NSError *error) {
                    NSLog(@"error %@", error);
                    [LLGHUD showErrorWithStatus:@"完成失败"];
                }];
                
            }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }];
    
   
    //再来一单
    [_bridge registerHandler:@"againOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dict = (NSDictionary *)data;
//
        NSLog(@"-------%@--------", dict);
        
//        fhdhwzl = 100;
//        fhdkspc = 100;
//        fhdxhcsxx = "\U5317\U4eac\U5e02\U4e1c\U57ce\U533a\U5d07\U6587\U95e8\U5916\U8857\U9053\U73ca\U745a\U80e1\U540c\U5317\U4eac\U5e02\U7b2c\U4e5d\U5341\U516d\U4e2d\U5b66(\U5357\U6821\U533a)";
//        fhdxhzb = "116.4164351343108,39.89481090017846";
//        fhdydj = "1000.0";
//        fhdyfdj = 10;
//        fhdyskdl = "0.1";
//        fhdzhcsxx = "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U4e1c\U5347\U9547\U6f47\U6e58\U66fe\U5e9c\U517b\U751f\U56ed(\U6e05\U6cb3\U5e97)";
//        fhdzhzb = "116.3644930880121,40.04016539480145";
//        hwlxmc = "\U6c7d\U6cb9";
//        jscs = "\U6c88\U9633\U5e02";
//        kscs = "\U77f3\U5bb6\U5e84\U5e02";
//        sfhs = 0;
//        xhlxrmc = "";
//        xhlxrsjh = "";
//        zhlxrmc = "\U5f20\U4e09";
//        zhlxrsjh = 1222222222222222222222222;
//        zzdz = "\U5317\U4eac\U5e02\U5927\U5174\U533a\U65e7\U5bab\U9547\U5f00\U53d1\U8def22\U53f7";
//        zzjwd = "116.4058803865401,39.78277866919719";

        //我要发货
        DeliveryTableViewController *toDeliveryVC = [[DeliveryTableViewController alloc]init];
        
        toDeliveryVC.navigationItem.title = @"我要发货";
        toDeliveryVC.dataDict = dict;
        [self.navigationController pushViewController:toDeliveryVC animated:YES];

    }];
    
    
    [self loadExamplePage:self.wkWebView urlStr:YBJOrderManagement_URL];
}


- (void)requestOrderStr:(NSDictionary *)orderStr urlStr:(NSString *)urlStr successBlock:(SucessBlock)sucess failBlock:(FailBlock)fail {
    
    
    
    NSDictionary *parameters = @{
                                 @"fhdbh": orderStr[@"bh"],
                                 @"fhdxtbh": orderStr[@"xtbh"],
                                 @"uuid": GetUuid
                                 };
    
    NSString *json = [NSString ObjectTojsonString:parameters];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *dict = @{@"basic": jsonBase64};
    
    //NSLog(@"%@", jsonBase64);
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:urlStr andParameters:dict andSuccessBlock:sucess andFailBlock:fail];
    
}

// 加载h5
- (void)loadExamplePage:(WKWebView*)webView urlStr:(NSString *)urlStr {
    
    //参数 uuid 用户id  pageSize
    NSString *orderManagement = [NSString stringWithFormat:@"%@?uuid=%@&pageSize=0", urlStr, GetUuid];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:orderManagement]]];
}


/*
 方法名
 orderDetail 订单详情
 call 运营专员
 againOrder  再来一单
 cancelOrder 取消发货
 signOrder 签约订单
 finishOrder 完成订单
 */
@end
