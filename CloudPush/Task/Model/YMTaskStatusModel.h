//
//  YMTaskStatusModel.h
//  Pods
//
//  Created by YouMeng on 2017/3/7.
//
//

#import "BaseModel.h"

@interface YMTaskStatusModel : BaseModel

//订单状态
@property(nonatomic,copy)NSString* status;
//明细描述
@property(nonatomic,copy)NSString* waiting_desc;
@property(nonatomic,copy)NSString* add_time;
//友盟返利金额
@property(nonatomic,copy)NSString* reward_money;
//项目名称
@property(nonatomic,copy)NSString* product_name;
//备注(30天标)
@property(nonatomic,copy)NSString* ps;

//平台名称
@property(nonatomic,copy)NSString* platform_name;
//图片链接
@property(nonatomic,copy)NSString* logo_path;
//投资金额
@property(nonatomic,copy)NSString* start_money;


//+ (NSDictionary *)mj_replacedKeyFromPropertyName;//替换模型与字典中不同的key

//字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
//+ (NSDictionary *)mj_objectClassInArray;//告知MJExtension 模型中包括的数组里是什么模型

@end
