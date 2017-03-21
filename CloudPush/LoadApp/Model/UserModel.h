//
//  UserModel.h
//  挑食
//
//  Created by Lucky on 16/11/28.
//  Copyright © 2016年 赵振龙. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

//登录的时间
@property(nonatomic,copy)NSString* date;
//用户名
@property(nonatomic,copy)NSString* phone;
//token
@property(nonatomic,copy)NSString* token;
//user_id
@property(nonatomic,copy)NSString* uid;
//用户名
@property(nonatomic,copy)NSString* username;

//累计收入
@property(nonatomic,copy)NSString* grandTotalMoeny;

//待发金额
@property(nonatomic,copy)NSString* readyMoney;
//可用余额
@property(nonatomic,copy)NSString* withdraw;
//余额账户
@property(nonatomic,copy)NSString* useMoeny;

//是否绑定支付宝
@property(nonatomic,copy)NSNumber* isCard;
//是否设置密码
@property(nonatomic,copy)NSNumber* isSetPasswd;
//是否绑定支付宝
@property(nonatomic,copy)NSNumber* isZfb;

//支付宝账户 真实姓名
@property(nonatomic,copy)NSString* isZfb_accountName;
@property(nonatomic,copy)NSString* isZfb_realName;

//银行卡账户 真实姓名
@property(nonatomic,copy)NSString* isCard_accountName;
@property(nonatomic,copy)NSString* isCard_realName;
@end
