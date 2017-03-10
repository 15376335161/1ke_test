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

//待处理
@property(nonatomic,strong)NSArray* pending;
@property(nonatomic,strong)NSArray* taskProject;
//审核中。
@property(nonatomic,strong)NSArray* audit_count;
@property(nonatomic,strong)NSArray* audit;
//审核成功
@property(nonatomic,strong)NSArray* orderSuccess;
@property(nonatomic,strong)NSArray* success;


//任务状态 1 待处理
@property(nonatomic,copy)NSString* del_status;
@property(nonatomic,copy)NSString* end_time;
@property(nonatomic,copy)NSString* id;
//价格
@property(nonatomic,copy)NSString* price;

@property(nonatomic,copy)NSString* task_title;

//失效原因 
@property(nonatomic,copy)NSString* audit_status;
//图片链接
@property(nonatomic,copy)NSString* imgPath;

//+ (NSDictionary *)mj_replacedKeyFromPropertyName;//替换模型与字典中不同的key

//字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
//+ (NSDictionary *)mj_objectClassInArray;//告知MJExtension 模型中包括的数组里是什么模型

@end
