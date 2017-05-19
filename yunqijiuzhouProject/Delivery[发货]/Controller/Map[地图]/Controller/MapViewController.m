//
//  MapViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "MapViewController.h"
#import "MAMapKit/MAMapKit.h"
#import "AMapFoundationKit/AMapFoundationKit.h"
#import "AMapSearchKit/AMapSearchKit.h"
#import "JCAlertController.h"

@interface MapViewController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource>

//搜索对象
@property (nonatomic, strong) AMapSearchAPI *search;
//逆地理请求参数
@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
//地理请求参数
@property (nonatomic, strong) AMapGeocodeSearchRequest *geo;
//搜索请求参数
@property (nonatomic, strong) AMapInputTipsSearchRequest *tips;
//标记
@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;
//地图
@property (nonatomic, strong) MAMapView *mapView;

//搜索展示
@property (nonatomic, strong) UITableView *searchShowView;
//搜索展示数据源
@property (nonatomic, strong) NSArray *searchShowData;

//搜索框
@property (nonatomic, weak) UITextField *searchText;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"定位";
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    
    self.mapView.delegate = self;
    
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 80 - 8, 8, 80, 40)];
    [searchButton addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    [searchButton setBackgroundColor:[UIColor redColor]];
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    [self.view addSubview:searchButton];
    
    UITextField *searchText = [[UITextField alloc]initWithFrame:CGRectMake(8, 8, ScreenW - 80 - 8 * 3, 40)];
    searchText.borderStyle = UITextBorderStyleRoundedRect;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.tintColor = [UIColor redColor];
    searchText.placeholder = @"请输入搜索地点";
    searchText.layer.borderColor = [UIColor redColor].CGColor;
    searchText.layer.borderWidth = 1;
    searchText.layer.cornerRadius = 5;
    searchText.layer.masksToBounds = YES;
    [self.view addSubview:searchText];
    self.searchText = searchText;
    
    //监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:searchText];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textGetFocus:) name:UITextFieldTextDidBeginEditingNotification object:searchText];
}

- (void)textChange:(NSNotification *)noti {

    UITextField *textField = noti.object;
    
    self.searchShowView.hidden = textField.text.length <= 0;
    
    //NSLog(@"%@", textField.text);
    
    self.tips.keywords = textField.text;
    
    [self.search AMapInputTipsSearch:self.tips];
    
}

//搜索功能
- (void)clickSearchButton {
    
    //[self.searchShowView removeFromSuperview];
    self.searchShowView.hidden = YES;
    
    self.geo.address = self.searchText.text;
    
    [self.search AMapGeocodeSearch:self.geo];
    
    
}


//地图代理方法
//修改图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"ygc"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

/**
 * @brief 单击地图底图调用此接口
 * @param mapView    地图View
 * @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self.coordinate2D = coordinate;
    
    //缩放比例
    [self.mapView setZoomLevel:16 animated:YES];
    
    //调整中心
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    self.pointAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:self.pointAnnotation];
    
    self.regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //查找
    [self.search AMapReGoecodeSearch:self.regeo];
    
}

/* 地理编码回调. */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    
    if (response.geocodes.count == 0) {
        return;
    }
    
    AMapGeocode *geocode = response.geocodes.firstObject;
    
    CLLocationCoordinate2D coordinate = {
        geocode.location.latitude,
        geocode.location.longitude
    };
    
    //缩放比例
    [self.mapView setZoomLevel:15 animated:YES];
    
    //调整中心
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        
        AMapReGeocode *regeocode = response.regeocode;
        
        //NSLog(@"%@", regeocode.formattedAddress);
        
        JCAlertController *alert = [JCAlertController alertWithTitle:@"定位" message:regeocode.formattedAddress type:JCAlertTypeNormal];
        
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:^{
            
        }];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:AddressNotification object:regeocode.formattedAddress userInfo:@{@"index": @(self.index), @"latitude": @(self.coordinate2D.latitude), @"longitude": @(self.coordinate2D.longitude)}];
            
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
        
    }
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    [response.tips enumerateObjectsUsingBlock:^(AMapTip * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arrayM addObject:obj];
    }];
    
    self.searchShowData = arrayM.copy;
    
    [self.searchShowView reloadData];
}


//tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchShowData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    AMapTip *tip = self.searchShowData[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
    
    cell.textLabel.font = TextFont14;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapTip *tip = self.searchShowData[indexPath.row];
    
    self.searchText.text = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
    
    //[tableView removeFromSuperview];
    self.searchShowView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//懒加载
- (AMapSearchAPI *)search {

    if (_search == nil) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    
    return _search;
}

- (AMapReGeocodeSearchRequest *)regeo {

    if (_regeo == nil) {
        _regeo = [[AMapReGeocodeSearchRequest alloc] init];
        _regeo.requireExtension = YES;
    }
    return _regeo;
}

- (AMapGeocodeSearchRequest *)geo {
    
    if (_geo == nil) {
        _geo = [[AMapGeocodeSearchRequest alloc] init];
    }
    return _geo;
}

- (AMapInputTipsSearchRequest *)tips {

    if (_tips == nil) {
        _tips = [[AMapInputTipsSearchRequest alloc]init];
    }
    
    return _tips;
}


- (MAPointAnnotation *)pointAnnotation {

    if (_pointAnnotation == nil) {
        _pointAnnotation = [[MAPointAnnotation alloc]init];
    }
    return _pointAnnotation;
}

- (UITableView *)searchShowView {

    if (_searchShowView == nil) {
        _searchShowView = [[UITableView alloc]initWithFrame:CGRectMake(8, 8 + 40, ScreenW - 80 - 8 * 3, 30 * 10)];
        _searchShowView.delegate = self;
        _searchShowView.dataSource = self;
        _searchShowView.rowHeight = 30;
        _searchShowView.bounces = NO;
        [_searchShowView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [self.view addSubview:_searchShowView];
    }
    return _searchShowView;
}

@end
