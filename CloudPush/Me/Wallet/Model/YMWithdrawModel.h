//
//  YMWithdrawModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseModel.h"

@interface YMWithdrawModel : BaseModel

@property(nonatomic,copy)NSString* date;
//状态描述
@property(nonatomic,copy)NSString* statusDesc;

//提取方式
@property(nonatomic,copy)NSString* extractDesc;
@property(nonatomic,copy)NSString* account;

@property(nonatomic,copy)NSString* money;
@property(nonatomic,copy)NSString* month;

//1 提取成功。2 提取中。 3 提取失败
@property(nonatomic,strong)NSNumber* status;
@end
