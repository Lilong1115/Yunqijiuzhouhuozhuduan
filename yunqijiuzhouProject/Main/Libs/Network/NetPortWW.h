//
//  NetPortWW.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/3.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#ifndef NetPortWW_h
#define NetPortWW_h

#define Base_URL @"http://www.yun9zhou.com/"

//222.35.27.155:8888
//192.168.100.201:8080
//192.168.100.137:8080

//47.93.46.18:8080

//www.yun9zhou.com


//头像路径 -- http://222.35.27.155:8888 图片基础url
#define PhotoBase_URL @"http://www.yun9zhou.com"

//首页
#define Home_URL [NSString stringWithFormat:@"%@MovewebhomeCon.con/index", Base_URL]

//城市接口
#define CityAddress_URL [NSString stringWithFormat:@"%@RrgisterCon.con/Address", Base_URL]
//@"http://192.168.100.136:8080/antu/RrgisterCon.con/Address"
//油品类型
#define OilType_URL [NSString stringWithFormat:@"%@RrgisterCon.con/gasoline", Base_URL]
//@"http://192.168.100.136:8080/antu/XgoodsCon.con/hwlx"
//登录
#define Login_URL [NSString stringWithFormat:@"%@login.con/login", Base_URL]
//@"http://192.168.100.136:8080/antu/login.con/login"

//修改照片
#define SaveIcon_URL [NSString stringWithFormat:@"%@androidModInfo.con/modiInfo", Base_URL]
//@"http://192.168.100.136:8080/antu/androidModInfo.con/modiInfo"
//提交发货
#define Delivery_URL [NSString stringWithFormat:@"%@AndroidIndentCon.con/Addindent", Base_URL]
//@"http://192.168.100.136:8080/antu/AndroidIndentCon.con/Addindent"

//服务协议
#define ServiceAgreement_URL [NSString stringWithFormat:@"%@serverDeal.con/getServerDeal", Base_URL]
//@"http://192.168.100.136:8080/antu/serverDeal.con/getServerDeal"
//意见提交
#define SubmitOption_URL [NSString stringWithFormat:@"%@serverDeal.con/addOption", Base_URL]
//@"http://192.168.100.136:8080/antu/serverDeal.con/addOption"

//取消订单
#define CancelOrder_URL [NSString stringWithFormat:@"%@AndroidIndentCon.con/cancelindent", Base_URL]

//确认订单
#define ConfirmOrder_URL [NSString stringWithFormat:@"%@AndroidIndentCon.con/updateindent", Base_URL]

//订单完成
#define CompletedOrder_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/OWindent", Base_URL]

//h5
//订单管理
//已发布
#define YBJOrderManagement_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/NOindent", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebindentCon.con/QuotedIndent"
//已签约
#define YQYOrderManagement_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/YESindent", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebindentCon.con/SignedIndent"
//已完成
#define YWCOrderManagement_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/OWindent", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebindentCon.con/CompletedIndent"
//订单详情
#define OrderDetails_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/ShipperCheck", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebindentCon.con/OwnerCheck"
//运输协议
#define TransportAgreement_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/TransportAgreement", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebindentCon.con/TransportAgreement"
//车辆定位
#define CarsPosition_URL [NSString stringWithFormat:@"%@MovewebManageCon.con/carsInfoPosition", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebManageCon.con/carsInfoPosition"
//定位
#define Position_URL [NSString stringWithFormat:@"%@", Base_URL]
//@"http://192.168.100.136:8080/antu/"
//查看任务
#define Task_URL [NSString stringWithFormat:@"%@MovewebManageCon.con/task", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebManageCon.con/task"
//查看装货单
#define CheckZhdInvoice_URL [NSString stringWithFormat:@"%@MovewebManageCon.con/selectZhd", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebManageCon.con/selectZhd"
//查看卸货单
#define CheckXhdInvoice_URL [NSString stringWithFormat:@"%@MovewebManageCon.con/selectXhd", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebManageCon.con/selectXhd"


//圈子
#define Circle_URL [NSString stringWithFormat:@"%@MovewebcircleCon.con/circle?yhbh=", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebcircleCon.con/circle?yhbh="

//添加圈子
#define AddCircle_URL [NSString stringWithFormat:@"%@MovewebcircleCon.con/addcircle?yhbh=", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebcircleCon.con/addcircle?yhbh="

//商城
#define Mall_URL [NSString stringWithFormat:@"%@MovewebMySettingsCon.con/IntegralShop?yhbh=", Base_URL]
//@"http://192.168.100.136:8080/antu/MovewebMySettingsCon.con/IntegralShop?yhbh="

//注册
#define Register_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/register", Base_URL]
//@"http://192.168.100.134:8999/antu/MovewebindentCon.con/register"


//账号绑定
#define Account_URL [NSString stringWithFormat:@"%@yelistCon.con/Balance", Base_URL]

//绑定银行卡
#define BindingAccount_URL [NSString stringWithFormat:@"%@AddBankCon.con/BindingAccount", Base_URL]

//更多
#define More_URL [NSString stringWithFormat:@"%@MovewebhomeCon.con/MoreOils", Base_URL]

//搜索油品类型
#define OilTypes_URL [NSString stringWithFormat:@"%@XgoodsCon.con/hwlx", Base_URL]

//提现
#define Withdraw_URL [NSString stringWithFormat:@"%@withdraws.con/withdraw", Base_URL]

//余额查询
#define Balance_URL [NSString stringWithFormat:@"%@AndroidBankCon.con/RefreshSelect", Base_URL]

//交易记录
#define Tradeindent_URL [NSString stringWithFormat:@"%@MovewebMySettingsCon.con/Tradeindent?yhbh=", Base_URL]

//修改支付密码
#define ModifyPaymentPassword_URL [NSString stringWithFormat:@"%@ModifyPwdCon.con/ModifyPwd", Base_URL]
//http://192.168.100.232:8080/antu/ModifyPwdCon.con/ModifyPwd?uuid=&yhsjh=
//忘记支付密码
#define ForgetPaymentPassword_URL [NSString stringWithFormat:@"%@ModifyPwdCon.con/forgetPwd", Base_URL]

//消息
#define Message_URL [NSString stringWithFormat:@"%@xxlistCon.con/xxList?token=", Base_URL]

//支付运费
#define PaymentList_URL [NSString stringWithFormat:@"%@MovewebindentCon.con/PaymentList", Base_URL]

//运费
#define SendCarPlanInfo_URL [NSString stringWithFormat:@"%@MovewebManageCon.con/sendCarPlanInfo", Base_URL]

//支付
#define Paymentmoney_URL [NSString stringWithFormat:@"%@MovewebManageCon.con/Paymentmoney", Base_URL]

//线下支付@"AndroidLinePayCon.con/LinePay"
#define OfflinePay_URL [NSString stringWithFormat:@"%@AndroidLinePayCon.con/LinePay", Base_URL]
//线上支付
#define OnlinePay_URL [NSString stringWithFormat:@"%@PayforCon.con/gopay", Base_URL]

#endif /* NetPortWW_h */
