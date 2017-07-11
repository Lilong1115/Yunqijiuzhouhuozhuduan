//
//  MineTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/17.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "MineTableViewController.h"
#import "UserInfo.h"
#import "MMNavigationController.h"
#import "PersonalDataTableViewController.h"
#import "WithdrawalViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"

@interface MineTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation MineTableViewController


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if ([UserInfo account]) {
        
        NSString *photo = GetIcon;
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoBase_URL, photo]]];
        
        self.userName.text = [UserInfo account].userName;
    } else {
        self.iconView.image = [UIImage imageNamed:@"avatar_default"];
        self.userName.text = @"请先登录";
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconView.layer.cornerRadius = 40;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 5;
    
    //图像添加点击事件（手势方法）
    self.iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.iconView.contentMode = UIViewContentModeScaleToFill;
    [self.iconView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"logout" object:nil];
    
}

- (void)logout:(NSNotification *)noti {

    self.iconView.image = [UIImage imageNamed:@"avatar_default"];
    self.userName.text = @"请先登录";
    
}

//头像手势
- (void)tap:(UITapGestureRecognizer *)tap {

    [self toLoginWithSBoardStr:@"PersonalData"];
}

//去登陆
- (void)toLoginWithSBoardStr:(NSString *)sBoardStr {

    if ([UserInfo account]) {
        
        // - 获取storyboard文件
        UIStoryboard *sBoard = [UIStoryboard storyboardWithName:sBoardStr bundle:nil];
        
        // - 实例化文件中的初始化控制器[或者根据标记实例化控制器]
        // 多态,父类的指针指向之类的对象!
        UITableViewController *VC = [sBoard instantiateInitialViewController];
        
        [self.navigationController pushViewController:VC animated:YES];
        
    } else {
        
        
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"请先登录" type:JCAlertTypeNormal];
        
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
            
            // - 获取storyboard文件
            UIStoryboard *sBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            
            // - 实例化文件中的初始化控制器[或者根据标记实例化控制器]
            // 多态,父类的指针指向之类的对象!
            LoginViewController *loginVC = [sBoard instantiateInitialViewController];
            
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self toLoginWithSBoardStr:@"PersonalData"];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self toLoginWithSBoardStr:@"Wallet"];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        [self toLoginWithSBoardStr:@"Mall"];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
    
        MessageViewController *vc = [[MessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
    
        [LLGHUD showInfoWithStatus:@"正在开发中..."];
    }
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
