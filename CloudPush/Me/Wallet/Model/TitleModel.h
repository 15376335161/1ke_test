//
//  TitleModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseModel.h"

@interface TitleModel : BaseModel

@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* icon;

//提现方式
@property(nonatomic,assign)WithDrawCrashStyle withdrawStyle;

//添加标记 便于判断 跳转
@property(nonatomic,strong)NSNumber* isCard;
@property(nonatomic,strong)NSNumber* isZfb;

@end
