//
//  PaymentManagementController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/10.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//
//支付管理
#import "PaymentManagementController.h"
#import "ModifyPaymentPasswordController.h"

@interface PaymentManagementController ()

@end

@implementation PaymentManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付管理";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.bounces = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"修改支付密码";
            break;
        case 1:
            cell.textLabel.text = @"忘记支付密码";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        ModifyPaymentPasswordController *vc = [[ModifyPaymentPasswordController alloc]init];
        vc.navTitle = @"修改支付密码";
        vc.urlStr = ModifyPaymentPassword_URL;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
    
        ModifyPaymentPasswordController *vc = [[ModifyPaymentPasswordController alloc]init];
        vc.navTitle = @"忘记支付密码";
        vc.urlStr = ForgetPaymentPassword_URL;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
