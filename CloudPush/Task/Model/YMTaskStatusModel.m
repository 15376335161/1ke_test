//
//  YMTaskStatusModel.m
//  Pods
//
//  Created by YouMeng on 2017/3/7.
//
//

#import "YMTaskStatusModel.h"
#import "YMTaskModel.h"
#import "YMTaskNumModel.h"

@implementation YMTaskStatusModel

//将属性名换为其他key去字典中取值
//从字典中取值用的key
//+(id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
//    return @{
//             
//             };
//}
//替换模型与字典中不同的key
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    
//}

//字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
//告知MJExtension 模型中包括的数组里是什么模型
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             // @"myTaskList":@"YMTaskModel",
              @"taskProject":@"YMTaskModel",
              @"audit":@"YMTaskModel",
              @"success":@"YMTaskModel",
              @"pending":@"YMTaskNumModel",
              @"audit_count":@"YMTaskNumModel",
              @"orderSuccess":@"YMTaskNumModel"
            
             };
}

@end
