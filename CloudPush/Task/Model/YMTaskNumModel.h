//
//  YMTaskNumModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseModel.h"

@interface YMTaskNumModel : BaseModel

//任务数量
@property(nonatomic,copy)NSString* count_num;

////审核中
//@property(nonatomic,copy)NSString* audit_id;
//
////审核完成
//@property(nonatomic,copy)NSString* success_id;

//已失效
//@property(nonatomic,copy)NSString* id;

@end
