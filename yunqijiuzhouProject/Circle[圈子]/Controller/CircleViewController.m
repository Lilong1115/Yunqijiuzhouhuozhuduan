//
//  CircleViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/24.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "CircleViewController.h"
#import "UserInfo.h"

@interface CircleViewController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@property (weak, nonatomic) IBOutlet UITextField *contentText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *InputView;

//评论编码
@property (nonatomic, copy) NSString *msg;

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpWKWebView];
    
    //[self.view bringSubviewToFront:self.inputView];
    self.contentText.inputAccessoryView = [[UIView alloc]init];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.contentText endEditing:YES];
    self.tabBarController.tabBar.hidden = NO;
}

//评价
- (IBAction)sendContent:(UIButton *)sender {
    
    if (self.contentText.text.length == 0) {
        [LLGHUD showErrorWithStatus:@"评论不能为空"];
        return;
    }
    
    //返回数据
    NSString *str =  [NSString stringWithFormat:@"%@,%@,%@", self.msg, GetUuid, self.contentText.text];
    
    [_bridge callHandler:@"commitComment"data:str responseCallback:^(id responseData) {
        
    }];
    
    [self.contentText endEditing:YES];
    self.contentText.text = nil;
    self.tabBarController.tabBar.hidden = NO;
    
    //[self loadExamplePage:self.wkWebView urlStr:Circle_URL];
    
    
}


//相机
- (IBAction)camera:(UIBarButtonItem *)sender {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// viewWillAppear和viewWillDisappear对setWebViewDelegate处理，不处理会导致内存泄漏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    if (self.bridge) {
        [self.bridge setWebViewDelegate:self];
    }
    
    [self loadExamplePage:self.wkWebView urlStr:Circle_URL];
}

- (void)keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.inputView.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.inputView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
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
    self.wkWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 49)];
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    
    [self.view sendSubviewToBack:self.wkWebView];
    
    self.wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadExamplePage:self.wkWebView urlStr:Circle_URL];
        
//        [self.wkWebView.scrollView.mj_header endRefreshing];
    }];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    //弹出键盘
    [_bridge registerHandler:@"messageComment" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSLog(@"弹出键盘");
        
        NSString *msg = (NSString *)data;
        
        self.msg = msg;
        
        [self.contentText becomeFirstResponder];
        self.tabBarController.tabBar.hidden = YES;
        
    }];
    
    [_bridge registerHandler:@"click" handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"123");
        
        self.tabBarController.tabBar.hidden = self.contentText.editing == YES;
        
        
        
    }];
    
    
    
    [self loadExamplePage:self.wkWebView urlStr:Circle_URL];
}




// 加载h5
- (void)loadExamplePage:(WKWebView*)webView urlStr:(NSString *)urlStr {
    
    //加载司机当前任务
    //参数 uuid 用户id  pageSize
    NSString *URL = [NSString stringWithFormat:@"%@%@", urlStr, GetUuid];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
}


LoadWebViewHUD

//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//
//    [SVProgressHUD showWithStatus:@"正在加载..."];
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//
//    [SVProgressHUD dismiss];
//}

/*
 messageComment 输入评论
 commitComment  提交评论
 */


@end
