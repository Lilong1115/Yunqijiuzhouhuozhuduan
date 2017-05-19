//
//  MMTabBarController.m
//  neteaseLottery_cz30
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "MMTabBarController.h"
#import "MMBottomView.h"
#import "MMNavigationController.h"
#import "HomeViewController.h"
#import "UserInfo.h"
#import "LoginViewController.h"
                                // MARK: - 5.遵守协议
@interface MMTabBarController () <MMBottomViewDelegate>

@property (nonatomic, weak) MMBottomView *bottomView;

@end

@implementation MMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MARK: - 1.加载子控制器
    [self setupChildVcs];
    
    // MARK: - 2.添加底部的工具条
    [self setupBottomView];
    
    // 修改此属性,实现控制器的切换
//    self.selectedIndex = 1;
}

#pragma mark - 2.添加底部的工具条
- (void)setupBottomView {

    // MARK: - 1.添加底部视图
    // 1.创建
    MMBottomView *bottomView = [[MMBottomView alloc] init];
    
    // MARK: - 4.设置代理
    bottomView.delegate = self;
    
    // 2.设置背景
    bottomView.backgroundColor = [UIColor whiteColor];
    
    // 3.设置frame信息
    // 添加给了系统的tabBar,好处:将来在隐藏底部工具条的时候,自定义的工具条也会隐藏!
    bottomView.frame = self.tabBar.bounds;
    
    // 4.添加
    [self.tabBar addSubview:bottomView];
    
    self.bottomView = bottomView;
    
//    [self.view addSubview:bottomView];
    
    // MARK: - 2.遍历子控制器,bottomView去添加按钮
    // 1.遍历子控制器
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 拼接图片名称
        NSString *imgName = [NSString stringWithFormat:@"tab%@_normal", @(idx + 1)];
        NSString *selImgName = [NSString stringWithFormat:@"tab%@_selected", @(idx + 1)];
        
        // 创建两个图片
        UIImage *norImg = [UIImage imageNamed:imgName];
        UIImage *selImg = [UIImage imageNamed:selImgName];
        
        // 让bottomView添加一个按钮
        
        NSString *title;
        
        switch (idx) {
            case 0:
                title = @"首页";
                break;
            case 1:
                title = @"订单";
                break;
            case 2:
                title = @"发货";
                break;
            case 3:
                title = @"圈子";
                break;
            case 4:
                title = @"我的";
                break;
        }
        
        [bottomView addBtnWithImage:norImg andSelectImg:selImg title:title];
        
    }];


}

#pragma mark - 代理方法 MMBottomViewDelegate
// MARK: - 6.实现协议方法,切换控制器!
- (void)bottomView:(MMBottomView *)bottomView didSelectIndex:(NSUInteger)idx {

    self.selectedIndex = idx;
    
    if ([UserInfo account] == nil) {
        
        if (idx == 2 || idx == 1 || idx == 3) {
            
            self.selectedIndex = 4;
            self.bottomView.selectedIndex = 4;
            
            JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"请先登录" type:JCAlertTypeNormal];
            
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
                
                UIStoryboard *sBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                
                // - 实例化文件中的初始化控制器[或者根据标记实例化控制器]
                // 多态,父类的指针指向之类的对象!
                LoginViewController *loginVC = [sBoard instantiateInitialViewController];
                //LoginViewController *loginVC = [self navWithStoryboardName:@"Login"];
                
                [[self currentViewController].navigationController pushViewController:loginVC animated:YES];
            }];
            
            [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
            
        }
        
    }
    
    //NSLog(@"%ld", idx);
}

//获取Window当前显示的ViewController
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

#pragma mark - 1.加载子控制器
- (void)setupChildVcs {
    
    UINavigationController *homeVC = [self navWithStoryboardName:@"Home"];
    UINavigationController *orderVC = [self navWithStoryboardName:@"Order"];
    UINavigationController *deliveryVC = [self navWithStoryboardName:@"Delivery"];
    UINavigationController *circleVC = [self navWithStoryboardName:@"Circle"];
    UINavigationController *mineVC = [self navWithStoryboardName:@"Mine"];
    
    self.viewControllers = @[homeVC, orderVC, deliveryVC, circleVC, mineVC];
}

#pragma mark - 根据storyboard文件名称实例化其中带箭头的控制器
- (UINavigationController *)navWithStoryboardName:(NSString *)sbName {
    
    // - 获取storyboard文件
    UIStoryboard *sBoard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    
    // - 实例化文件中的初始化控制器[或者根据标记实例化控制器]
    // 多态,父类的指针指向之类的对象!
    UINavigationController *nav = [sBoard instantiateInitialViewController];
    
    // - 直接修改控制器的背景
    // 获取到航控制器内栈顶控制器
    //nav.topViewController.view.backgroundColor = RandomColor;
    
    // - 返回
    return nav;
}


@end
