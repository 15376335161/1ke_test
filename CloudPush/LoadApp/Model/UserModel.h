//
//  UserModel.h
//  挑食
//
//  Created by Lucky on 16/11/28.
//  Copyright © 2016年 赵振龙. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property(nonatomic,strong)NSString* date;
//用户名
@property(nonatomic,strong)NSString* phone;
//token
@property(nonatomic,strong)NSString* token;

@property(nonatomic,strong)NSString* uid;
//用户名
@property(nonatomic,strong)NSString* username;



@end
