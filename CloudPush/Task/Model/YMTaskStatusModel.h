//
//  YMTaskStatusModel.h
//  Pods
//
//  Created by YouMeng on 2017/3/7.
//
//

#import "BaseModel.h"

@interface YMTaskStatusModel : BaseModel

//订单列表
@property(nonatomic,strong)NSDictionary* myTaskList;

//订单数
@property(nonatomic,strong)NSDictionary* myTaskCounts;

//订单状态
@property(nonatomic,copy)NSString* myTaskStatus;


//+ (NSDictionary *)mj_replacedKeyFromPropertyName;//替换模型与字典中不同的key

//字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
//+ (NSDictionary *)mj_objectClassInArray;//告知MJExtension 模型中包括的数组里是什么模型

@end
