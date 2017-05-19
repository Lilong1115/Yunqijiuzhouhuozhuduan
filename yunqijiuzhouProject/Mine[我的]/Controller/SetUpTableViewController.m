//
//  SetUpTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/19.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "SetUpTableViewController.h"
#import "UserInfo.h"

@interface SetUpTableViewController ()

//退出按钮
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SetUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutButton.layer.cornerRadius = 5;
    self.logoutButton.layer.masksToBounds = YES;
    
    self.logoutButton.hidden = ![UserInfo account];
    
    //提示消失时通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:SVProgressHUDDidDisappearNotification object:nil];
}

- (void)logout:(NSNotification *)noti {

    NSString *hudStr = noti.userInfo[SVProgressHUDStatusUserInfoKey];
    
    if ([hudStr isEqualToString:@"退出成功"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLogoutButton:(UIButton *)sender {
    
    JCAlertController *alert = [JCAlertController alertWithTitle:@"退出登录" message:@"您确认要退出当前登录吗?" type:JCAlertTypeNormal];
    
    [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
    [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
        [UserInfo logoutAccount];
        
    }];
    
    [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];

}
@end
