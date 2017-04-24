//
//  YMStringTool.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMStringTool.h"

@implementation YMStringTool


//根据传人的数字 返回相应的中文状态
+(NSString* )getStatusByNumStatus:(NSString* )numStatus{
    if (numStatus.intValue == 1) {
        return @"收入待发";// 审计中
    }else if (numStatus.intValue == 2) {
        return  @"收入发放至余额";//@"审计成功";
    }else if (numStatus.intValue == 3) {
        return   @"收入发放失败";//@"审计失败";
    }else if (numStatus.intValue == 4) {
        return @"成功发放";
    }else{
        return @"";
    }
}
@end
