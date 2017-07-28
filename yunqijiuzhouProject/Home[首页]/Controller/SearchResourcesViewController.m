//
//  SearchResourcesViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/8.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

//搜索资源
#import "SearchResourcesViewController.h"
#import "OilModel.h"
#import "CallPhone.h"

@interface SearchResourcesViewController ()<WKNavigationDelegate, WKUIDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;

//picker内容
@property (nonatomic, strong) NSArray *arrayData;

@property (nonatomic, strong) OilModel *selectedModel;

@property (nonatomic, weak) UITextField *oilText;
@property (nonatomic, weak) UITextField *titleText;

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation SearchResourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.titleView = [self creatTitleView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    [self setUpWKWebView];
    
}

//搜索
- (void)search {

    NSString *str = [NSString stringWithFormat:@"%ld;%@", self.selectedModel.hwlxbh, self.titleText.text];
    
    [_bridge callHandler:@"JumpxOils" data:str responseCallback:^(id responseData) {
        
    }];
}

- (UITextField *)creatTitleView {

    UITextField *titleText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenW - 100, 30)];
    
    titleText.tintColor = [UIColor redColor];
    titleText.font = TextFont14;
    titleText.placeholder = @"请输入关键字搜索";
    
    titleText.layer.cornerRadius = 15;
    titleText.layer.masksToBounds = YES;
    titleText.backgroundColor = [UIColor whiteColor];
    
    UITextField *oilText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    //自定义键盘选择器
    self.picker = [[UIPickerView alloc] init];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    //选择指示器
    [self.picker setShowsSelectionIndicator:YES];
    
    [self requestData];
    self.selectedModel = self.arrayData[0];
    
    oilText.inputView = self.picker;
    
    oilText.text = @"轻油";
    oilText.font = TextFont14;
    oilText.textAlignment = NSTextAlignmentCenter;
    //oilText.backgroundColor = [UIColor redColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huisan"]];
    image.frame = CGRectMake(0, 0, 20 * 0.8, 16 * 0.8);
    oilText.rightView = image;
    oilText.rightViewMode = UITextFieldViewModeAlways;
    
    oilText.tintColor = [UIColor whiteColor];
    
    titleText.leftView = oilText;
    titleText.leftViewMode = UITextFieldViewModeAlways;

    self.oilText = oilText;
    self.titleText = titleText;
    
    return titleText;
}


//请求数据
- (void)requestData {
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:GET andUrlString:OilTypes_URL andParameters:nil andSuccessBlock:^(id result) {
        
        NSArray *array = (NSArray *)result;
        NSMutableArray *arrayM = [NSMutableArray array];
//        NSDictionary *dict = @{
//                               @"hwlxbh": @"",
//                               @"hwlxmc": @"全部"
//                               };
//        OilModel *model = [OilModel oilModelWithDict:dict];
//        [arrayM addObject:model];
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            OilModel *model = [OilModel oilModelWithDict:dict];
            
            [arrayM addObject:model];
            
        }];
        
        self.arrayData = arrayM.copy;
        
        [self.picker reloadComponent:0];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}


#pragma mark - UIPickerViewDelegate 和 UIPickerViewDataSource
//必须实现
// returns the number of 'columns' to display. ->选择器一共有多少列!
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component.. -> 选择器每列有多少行!
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrayData.count;
}

//选择器每行名称
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    OilModel *model = self.arrayData[row];
    
    return model.hwlxmc;
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    OilModel *model = self.arrayData[row];
    
    self.selectedModel = model;
    
    self.oilText.text = model.hwlxmc;
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
//        [self.wkWebView.scrollView.mj_header endRefreshing];
    }];
    
    //电话
    [_bridge registerHandler:@"Telephone" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *phone = (NSString *)data;
        
        [CallPhone callPhoneWithPhoneStr:phone];
        
    }];
    
    [self loadExamplePage:self.wkWebView];
}




// 加载h5
- (void)loadExamplePage:(WKWebView*)webView {
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:More_URL]]];
    
}

LoadWebViewHUD

@end
