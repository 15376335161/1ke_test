//
//  YMWithdrawController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"
#import "TitleModel.h"

@interface YMWithdrawController : BaseViewController

//用户模型数据
@property(nonatomic,strong)UserModel* usrModel;
//类型数组
@property(nonatomic,strong)TitleModel* model;

@property(nonatomic,assign)WithDrawCrashStyle withdrawStyle;

@end
