//
//  WalletTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/20.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "WalletTableViewController.h"
#import "AccountBindingViewController.h"
#import "UserInfo.h"
#import "PayFreightViewController.h"
#import "PaymentManagementController.h"
#import "PaymentListViewController.h"

@interface WalletTableViewController ()
//对公账户
@property (weak, nonatomic) IBOutlet UIView *publicAccountView;
//个人账户
@property (weak, nonatomic) IBOutlet UIView *privateAccountView;
//对公账户余额
@property (weak, nonatomic) IBOutlet UILabel *publicMoney;
//个人账户余额
@property (weak, nonatomic) IBOutlet UILabel *privateMoney;
//对公立即绑定
@property (weak, nonatomic) IBOutlet UILabel *publicBinding;
//个人立即绑定
@property (weak, nonatomic) IBOutlet UILabel *privateBinding;

@end

@implementation WalletTableViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //设置立即绑定是否隐藏
    self.publicBinding.hidden = ![[UserInfo account].gzzh isEqualToString:@"0"];
    
    self.privateBinding.hidden = ![[UserInfo account].szzh isEqualToString:@"0"];
    
    if (![[UserInfo account].gzzh isEqualToString:@"0"]) {
        [self requestBalanceWithYwlx:@"0"];
    }
    
    if (![[UserInfo account].szzh isEqualToString:@"0"]) {
        [self requestBalanceWithYwlx:@"1"];
    }
}

- (void)requestBalanceWithYwlx:(NSString *)ywlx {

    NSDictionary *dict = @{
                           @"uuid": GetUuid,
                           @"ywlx": ywlx
                           };
    
    NSString *json = [NSString ObjectTojsonString:dict];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{@"basic": jsonBase64};
    
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:Balance_URL andParameters:parameters andSuccessBlock:^(id result) {
        
        if ([result[@"msg"] isEqualToString:@"成功"]) {
            
            NSDictionary *dict = result[@"data"];
            
            NSString *str = dict[@"yhkje"];
            
            NSString *str1 = [NSString removeBlankSpace:str];
            
            NSString *string = [str1 substringToIndex:str1.length - 1];
            
            if ([ywlx isEqualToString:@"0"]) {
                self.publicMoney.text = [NSString stringWithFormat:@"￥%@", [string base64DecodedString]];
            } else {
                self.privateMoney.text = [NSString stringWithFormat:@"￥%@", [string base64DecodedString]];
            }
        } else {
            
            //NSLog(@"%@", result[@"msg"]);
            
            [LLGHUD showErrorWithStatus:@"数据请求失败"];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
    
    //绑定手势
    UITapGestureRecognizer *publicTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publicImmediatelyBinding:)];
    //绑定手势
    UITapGestureRecognizer *privateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(privateImmediatelyBinding:)];
    
    [self.publicAccountView addGestureRecognizer:publicTap];
    [self.privateAccountView addGestureRecognizer:privateTap];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (![[UserInfo account].gzzh isEqualToString:@"0"]) {
            [self requestBalanceWithYwlx:@"0"];
        }
        
        if (![[UserInfo account].szzh isEqualToString:@"0"]) {
            [self requestBalanceWithYwlx:@"1"];
        }
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
    
}

//对公立即绑定
- (void)publicImmediatelyBinding:(UITapGestureRecognizer *)tap {
    
    AccountBindingViewController *accountBindingVC = [[AccountBindingViewController alloc]init];
    
    accountBindingVC.urlStr = [NSString stringWithFormat:@"%@?yhbh=%@&ywlx=0", Account_URL, GetUuid];
    accountBindingVC.ywlx = @"0";
    if ([[UserInfo account].gzzh isEqualToString:@"1"]) {
        accountBindingVC.gzzhMoney = [self.publicMoney.text substringFromIndex:1];
    }
    
    [self.navigationController pushViewController:accountBindingVC animated:YES];
    
}

//个人立即绑定
- (void)privateImmediatelyBinding:(UITapGestureRecognizer *)tap {
    
    AccountBindingViewController *accountBindingVC = [[AccountBindingViewController alloc]init];
    
    accountBindingVC.urlStr = [NSString stringWithFormat:@"%@?yhbh=%@&ywlx=1", Account_URL, GetUuid];
    accountBindingVC.ywlx = @"1";
    if ([[UserInfo account].szzh isEqualToString:@"1"]) {
        accountBindingVC.grzhMoney = [self.privateMoney.text substringFromIndex:1];
    }
    
    [self.navigationController pushViewController:accountBindingVC animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 1) {
        PayFreightViewController *vc = [[PayFreightViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
    
        PaymentManagementController *vc = [[PaymentManagementController alloc]initWithStyle:UITableViewStylePlain];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
    
        PaymentListViewController *vc = [[PaymentListViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
