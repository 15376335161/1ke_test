//
//  YMWithdrawStyleController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"
#import "TitleModel.h"

@interface YMWithdrawStyleController : BaseViewController

//选择提现方式
@property(nonatomic,copy)void(^typeBlock)(WithDrawCrashStyle type,TitleModel* model);

//用户模型数据
@property(nonatomic,strong)UserModel* usrModel;

//支付方式
@property(nonatomic,assign)WithDrawCrashStyle withdrawStyle;

@end
