//
//  YMStringTool.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMStringTool : NSObject


//根据传人的数字 返回相应的中文状态
+(NSString* )getStatusByNumStatus:(NSString* )numStatus;
@end
