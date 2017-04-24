//
//  JSObjectUtil.h
//  WebView<->JS
//
//  Created by 宋飞龙 on 16/1/15.
//  Copyright © 2016年 Mr songfeilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//交互的协议方法
@protocol JSObjectDelegate <JSExport>

//JS调用OC去下一个视图的方法
//此方法名与网页端沟通 必须名字相同
- (void)jsGotoNextVC;

@end


//代理执行的协议方法

@protocol JSObjectData <NSObject>

//此为代理方法名
- (void)gotoNextVC1;
- (void)gotoNextVC2;

@end

@interface JSObjectUtil : NSObject
@property (nonatomic , assign) id<JSObjectData>delegate;

@end
