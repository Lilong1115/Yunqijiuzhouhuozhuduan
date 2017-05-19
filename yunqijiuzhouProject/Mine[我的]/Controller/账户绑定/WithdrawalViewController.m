//
//  WithdrawalViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "AccountTypeModel.h"
#import "WithdrawalView.h"
#import "UserInfo.h"
#import "passwordBar.h"
#import "NSString+Hash.h"

@interface WithdrawalViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIPickerView *picker;
//选择账户类型
@property (nonatomic, weak) UITextField *selectedText;

//账户类型
@property (nonatomic, strong) NSArray *accountTypeArray;
//选择的账户
@property (nonatomic, strong) AccountTypeModel *selectedTypeModel;

//提现面板
@property (nonatomic, weak) WithdrawalView *withdrawalView;

//密码
@property (nonatomic, strong) UITextField *passwordText;

//密码框
@property (nonatomic, weak) passwordBar *passwordBar;

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //账户类型
    UITextField *selectedText = [self creatSelectedText];
    [self.view addSubview:selectedText];
    self.selectedText = selectedText;
    
    //提现面板
    [self creatWithdrawalView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeValue:)   name:@"changeValue" object:self.passwordText];
}

-(void)changeValue:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    //要实现的监听方法操作
    
    //NSLog(@"%@", textField.text);
    
    self.passwordBar.password = textField.text;
    
    
}

- (void)creatWithdrawalView {

    WithdrawalView *withdrawalView = [[WithdrawalView alloc]initWithFrame:CGRectMake(8, 8 + 30 + 8, ScreenW - 2 * 8, 100)];
    [self.view addSubview:withdrawalView];
    self.withdrawalView = withdrawalView;
    
    __weak WithdrawalViewController *weakSelf = self;
    //全部提现
    withdrawalView.totalMoneyBlock = ^(){
    
        weakSelf.passwordBar.password = @"";
        weakSelf.passwordText.text = @"";
        
    };
    
    
    //判断设置余额
    if ([self.selectedTypeModel.accountID isEqualToString:@"0"]) {
        withdrawalView.totalMoney = self.gzzhMoney;
    } else {
        withdrawalView.totalMoney = self.grzhMoney;
    }
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"1-2个工作日到账";
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = TextFont14;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(withdrawalView.mas_bottom).mas_offset(8);
    }];
    
    UIButton *withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [withdrawalButton setTitle:@"提 现" forState:UIControlStateNormal];
    [withdrawalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawalButton setBackgroundColor:[UIColor redColor]];
    withdrawalButton.layer.cornerRadius = 5;
    withdrawalButton.layer.masksToBounds = YES;
    [self.view addSubview:withdrawalButton];
    [withdrawalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(8);
        make.leading.mas_equalTo(self.view).mas_offset(8);
        make.trailing.mas_equalTo(self.view).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    [withdrawalButton addTarget:self action:@selector(withdrawal:) forControlEvents:UIControlEventTouchUpInside];
    
    //密码
    self.passwordText = [[UITextField alloc]init];
    self.passwordText.delegate = self;
    self.passwordText.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //密码框
    self.passwordText.inputAccessoryView = [[passwordBar alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 110)];
    self.passwordBar = (passwordBar *)self.passwordText.inputAccessoryView;
    [self.view addSubview:self.passwordText];
    
    
    //完成回调
    self.passwordBar.completeBlock = ^(){
    
        [weakSelf.view endEditing:YES];
        
        if (weakSelf.passwordText.text.length == 6) {
            
            [weakSelf.view endEditing:YES];
            JCAlertController *alert = [[JCAlertController alloc]initWithTitle:@"提示" message:@"确认提现?" type:JCAlertTypeNormal];
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
                
                [weakSelf complete];
            }];
            
            [weakSelf jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        }
        
        self.passwordBar.password = @"";
        self.passwordText.text = @"";
        
    };
    
}

//提现
- (void)complete {
    
    NSDictionary *parameters = @{
                                 @"yhjymm": [self.passwordText.text md5String],
                                 @"pay_amt": self.withdrawalView.money,
                                 @"yhbh": GetUuid,
                                 @"ywlx": self.selectedTypeModel.accountID
                                 };
    
    NSString *json = [NSString ObjectTojsonString:parameters];
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *dict = @{@"basic": jsonBase64};
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:Withdraw_URL andParameters:dict andSuccessBlock:^(id result) {
        
        //NSLog(@"%@", result[@"msg"]);
        
        if ([result[@"msg"] isEqualToString:@"成功"]) {
            [LLGHUD showSuccessWithStatus:@"提现成功,1-2个工作日到账"];
            NSArray *pushVCAry=[self.navigationController viewControllers];
            
            
            //下面的pushVCAry.count-3 是让我回到视图1中去
            
            UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
            
            [self.navigationController popToViewController:popVC animated:YES];
        } else {
            [LLGHUD showErrorWithStatus:result[@"msg"]];
            
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];

}

- (void)textFieldDidChange:(UITextField *)textField {
    
    //NSLog(@"%@", textField.text);
    
    //self.passwordBar.password = textField.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:textField];
}

//账户类型
- (UITextField *)creatSelectedText {
    
    UITextField *selectedText = [[UITextField alloc]initWithFrame:CGRectMake(8, 8, 120, 30)];
    
    //自定义键盘选择器
    self.picker = [[UIPickerView alloc] init];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    //选择指示器
    [self.picker setShowsSelectionIndicator:YES];
    selectedText.inputView = self.picker;
    
    self.accountTypeArray = [AccountTypeModel getAccountType];
    self.selectedTypeModel = self.accountTypeArray[0];
    selectedText.text = self.selectedTypeModel.account;
    
    selectedText.borderStyle = UITextBorderStyleRoundedRect;
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huisan"]];
    image.frame = CGRectMake(0, 0, 20 * 0.8, 16 * 0.8);
    selectedText.rightView = image;
    selectedText.rightViewMode = UITextFieldViewModeAlways;
    
    selectedText.tintColor = [UIColor whiteColor];
    
    return selectedText;
}

//提现
- (void)withdrawal:(UIButton *)button {
    
    if (self.withdrawalView.money.length > 0) {
        
        //判断金额数不得大于余额
        if ([self.withdrawalView.money floatValue] > [self.withdrawalView.totalMoney floatValue]) {
            [LLGHUD showErrorWithStatus:@"输入金额不得大于余额"];
        } else {
            
            [self.passwordText becomeFirstResponder];
        }
        
    } else {
        [LLGHUD showErrorWithStatus:@"请输入提现金额"];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPickerViewDelegate 和 UIPickerViewDataSource
//必须实现
// returns the number of 'columns' to display. ->选择器一共有多少列!
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component.. -> 选择器每列有多少行!
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.accountTypeArray.count;
}

//选择器每行名称
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    AccountTypeModel *model = self.accountTypeArray[row];
    
    return model.account;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    AccountTypeModel *model = self.accountTypeArray[row];
    self.selectedTypeModel = model;
    self.selectedText.text = model.account;
    self.withdrawalView.accountTypeModel = model;
    self.passwordBar.password = @"";
    self.passwordText.text = @"";
    
    if ([self.selectedTypeModel.accountID isEqualToString:@"0"]) {
        self.withdrawalView.totalMoney = self.gzzhMoney;
    } else {
        self.withdrawalView.totalMoney = self.grzhMoney;
    }
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//textfield代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location >= 6)
        
        return NO;
    
    return YES;
    
}



@end
