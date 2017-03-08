//
//  YMTaskModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/3.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseModel.h"

@interface YMTaskModel : BaseModel

//时间
@property(nonatomic,copy)NSString* add_time;
//区域
@property(nonatomic,copy)NSString* city;
//状态
@property(nonatomic,copy)NSString* del_status;
//结束时间
@property(nonatomic,copy)NSString* end_time;

@property(nonatomic,strong)NSNumber* id;
//图片
@property(nonatomic,copy)NSString* img_path;
//价格
@property(nonatomic,copy)NSString* price;
//文案内容
@property(nonatomic,copy)NSString* short_des;
//剩余单数数量
@property(nonatomic,copy)NSString* surplu_nums;
//总的单数
@property(nonatomic,copy)NSString* task_nums;

@property(nonatomic,strong)NSNumber* task_status;
@property(nonatomic,copy)NSString* task_type_id;
//任务标题
@property(nonatomic,copy)NSString* task_title;
//是否置顶
@property(nonatomic,assign)BOOL zhiding;

//业务概要
@property(nonatomic,copy)NSString* outline;
//审核标准
@property(nonatomic,copy)NSString* audit;
//计费模式
@property(nonatomic,copy)NSString* billing_mode;
//推广目标
@property(nonatomic,copy)NSString* target;
//推广区域
@property(nonatomic,copy)NSString* spread_area;

@end
