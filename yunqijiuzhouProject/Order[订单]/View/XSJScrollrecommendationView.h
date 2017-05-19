//
//  XSJScrollrecommendationView.h
//  salesPlatform
//
//  Created by 李龙 on 17/3/7.
//  Copyright © 2017年 xiaoshoujia.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮选种界面类型
typedef enum: NSUInteger{
    
    selectedTypeTodayRecommendation = 1000,
    selectedTypeOfflineRecommendation = 1001,
    selectedTypeOnlineRecommendation = 1002,
}selectedType;

@interface XSJScrollrecommendationView : UIView

//声明block
@property (nonatomic, copy) void(^clickTypeBlock)(selectedType);

//选中数字
@property (nonatomic, assign) NSInteger clickNum;

//第一个按钮文字
@property (nonatomic, strong) NSString *firstButtonTitle;
//第二个按钮文字
@property (nonatomic, strong) NSString *secondButtonTitle;
//第三个按钮文字
@property (nonatomic, strong) NSString *thirdButtonTitle;
@end
