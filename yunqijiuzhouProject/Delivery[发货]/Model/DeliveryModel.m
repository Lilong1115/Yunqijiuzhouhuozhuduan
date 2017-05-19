//
//  DeliveryModel.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/18.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "DeliveryModel.h"

@interface DeliveryModel()

//数据参数字典
@property (nonatomic, strong) NSMutableDictionary *dictM;

@end

@implementation DeliveryModel


+ (instancetype)deliveryModelWithdict:(NSDictionary *)dict {

    DeliveryModel *model = [[DeliveryModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (void)setNilValueForKey:(NSString *)key {

    
}

- (void)insertValue:(NSString *)value key:(NSString *)key {

    if (value == nil) {
        return;
    } else {
        [self.dictM setValue:value forKey:key];
    }
}

- (void)submitDataWithSuccessBlock:(SucessBlock)sucess failBlock:(FailBlock)fail {
    
    //NSLog(@"是否含税 %@", _sfhs);
    
    [self insertValue:_uuid key:@"uuid"];
    [self insertValue:_fhdhwzl key:@"fhdhwzl"];
    [self insertValue:_fhdjscs key:@"fhdjscs"];
    [self insertValue:_fhdkscs key:@"fhdkscs"];
    [self insertValue:_fhdkspc key:@"fhdkspc"];
    [self insertValue:_fhdxhzb key:@"fhdxhzb"];
    [self insertValue:_fhdydj key:@"fhdydj"];
    [self insertValue:_fhdyfdj key:@"fhdyfdj"];
    [self insertValue:_fhdyskdl key:@"fhdyskdl"];
    [self insertValue:_fhdzhzb key:@"fhdzhzb"];
    [self insertValue:_jscs key:@"jscs"];
    [self insertValue:_kscs key:@"kscs"];
    [self insertValue:_zzjwd key:@"zzjwd"];
    [self insertValue:_fhdbz key:@"fhdbz"];
    [self insertValue:_fhdhwlx key:@"fhdhwlx"];
    [self insertValue:_fhdthrq key:@"fhdthrq"];
    [self insertValue:_fhdxhcsxx key:@"fhdxhcsxx"];
    [self insertValue:_fhdzhcsxx key:@"fhdzhcsxx"];
    [self insertValue:_sfhs key:@"sfhs"];
    [self insertValue:_xhlxrmc key:@"xhlxrmc"];
    [self insertValue:_zzdz key:@"zzdz"];
    [self insertValue:_xhlxrsjh key:@"xhlxrsjh"];
    [self insertValue:_zhlxrmc key:@"zhlxrmc"];
    [self insertValue:_zhlxrsjh key:@"zhlxrsjh"];
    
    NSString *json = [NSString ObjectTojsonString:self.dictM.copy];
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    NSDictionary *parameters = @{
                                 @"basic": jsonBase64
                                 };
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:Delivery_URL andParameters:parameters andSuccessBlock:sucess andFailBlock:fail];
    
}

//货物重量
- (void)setFhdhwzl:(NSString *)fhdhwzl {
    
    if (fhdhwzl == nil) {
        _fhdhwzl = @"0";
    } else {
        _fhdhwzl = fhdhwzl;
    }
}

//运输单价
- (void)setFhdydj:(NSString *)fhdydj {

    if (fhdydj == nil) {
        _fhdydj = @"0";
    } else {
        _fhdydj = fhdydj;
    }
}

//预付定金
- (void)setFhdyfdj:(NSString *)fhdyfdj {
    
    if (fhdyfdj == nil) {
        _fhdyfdj = @"0";
    } else {
        _fhdyfdj = fhdyfdj;
    }
}

//允许亏吨量
- (void)setFhdyskdl:(NSString *)fhdyskdl {
    
    if (fhdyskdl == nil) {
        _fhdyskdl = @"0";
    } else {
        _fhdyskdl = fhdyskdl;
    }
}

//赔偿
- (void)setFhdkspc:(NSString *)fhdkspc {
    
    if (fhdkspc == nil) {
        _fhdkspc = @"0";
    } else {
        _fhdkspc = fhdkspc;
    }
}

//出发地经纬度
- (void)setFhdzhzb:(NSString *)fhdzhzb {

    if (fhdzhzb == nil) {
        _fhdzhzb = @"0-0";
    } else {
        _fhdzhzb = fhdzhzb;
    }
}

//目的地经纬度
- (void)setFhdxhzb:(NSString *)fhdxhzb {
    
    if (fhdxhzb == nil) {
        _fhdxhzb = @"0-0";
    } else {
        _fhdxhzb = fhdxhzb;
    }
}

//中转经纬度
- (void)setZzjwd:(NSString *)zzjwd {
    
    if (zzjwd == nil) {
        _zzjwd = @"0-0";
    } else {
        _zzjwd = zzjwd;
    }
}

- (void)setFhdthrq:(NSString *)fhdthrq {
    
    _fhdthrq = [NSString creatTimeStr:fhdthrq];;

}


- (NSMutableDictionary *)dictM {

    if (_dictM == nil) {
        _dictM = [NSMutableDictionary dictionary];
    }
    
    return _dictM;
}


@end
