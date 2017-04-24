//
//  TextActionProxy.m
//  IOS-JsAndNativeDemo
//
//  Created by zhangPeng on 16/8/22.
//  Copyright © 2016年 ZhangPeng. All rights reserved.
//

#import "TestActionProxy.h"



@implementation TestActionProxy

//获取版本号
- (NSString *)getVersion{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // return 返回的就是js需要的值
    return app_Version;
    
}
//加法
- (NSInteger)get:(id)number1 Num:(id)number2 Sum:(id)number3{
    
     NSInteger result = [number1 integerValue] + [number2 integerValue] +  [number3 integerValue];
    
    return result;
}

- (NSInteger)getNumsumNumber1:(id)num1 number2:(id)num2 number3:(id)num3{
    
    NSInteger result = [num1 integerValue] + [num2 integerValue] + [num3 integerValue];
    
    return result;
}


//调用弹框
- (void)showNotice{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLog(@"🉐️难过了");

    });
    
    
}




@end
