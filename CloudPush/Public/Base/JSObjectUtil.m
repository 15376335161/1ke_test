//
//  JSObjectUtil.m
//  WebView<->JS
//
//  Created by 宋飞龙 on 16/1/15.
//  Copyright © 2016年 Mr songfeilong. All rights reserved.
//

#import "JSObjectUtil.h"

@implementation JSObjectUtil

- (void)jsGotoNextVC {
    NSArray * array = [JSContext currentArguments];//此处为网页传值所在数组
    //多个参数直接遍历数组 存为字典传出
    //判断网页传过来的是否有参数
    //因不会写简单的html代码，具体传值在webview代理方法里面模拟
    //如为1 去VC1
    if ([[array[0] toString] isEqualToString:@"1"]) {
        [self.delegate gotoNextVC1];
    } else if ([[array[0] toString] isEqualToString:@"2"]) {
         //如为2 去VC2
        [self.delegate gotoNextVC2];
    }
}

//可通过代理传参数
- (void)gotoNextVC1 {
    
}
- (void)gotoNextVC2 {
    
}

@end
