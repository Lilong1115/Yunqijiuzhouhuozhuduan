//
//  ServiceAgreementViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/19.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "ServiceAgreementViewController.h"
#import <WebKit/WebKit.h>

@interface ServiceAgreementViewController ()

@property (nonatomic, strong) WKWebView *webWiew;

@property (nonatomic, weak) UILabel *myLabel;

@end

@implementation ServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:myLabel];
    
    self.myLabel = myLabel;
    
    [self requestData];
}

- (void)requestData {

    NSDictionary *dict = @{
                           @"xylx": @"0",
                           @"htgllx": @"1"
                           };
    
    NSString *json = [NSString ObjectTojsonString:dict];
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{
                                 @"basic": jsonBase64
                                 };
    
    //NSString *str = [NSString stringWithFormat:@"%@?basic=%@", ServiceAgreement_URL, jsonBase64];
    
    //self.webWiew = [[WKWebView alloc]initWithFrame:self.view.bounds];
    
    //[self.view addSubview:self.webWiew];
    
    //[self.webWiew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    //NSLog(@"%@", str);
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:GET andUrlString:ServiceAgreement_URL andParameters:parameters andSuccessBlock:^(id result) {
        
        NSString *data = result[@"data"];
        
        //NSLog(@"%@", data);
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[data dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        
        self.myLabel.attributedText = attrStr;
        
        
    } andFailBlock:^(NSError *error) {
        //NSLog(@"%@", error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
