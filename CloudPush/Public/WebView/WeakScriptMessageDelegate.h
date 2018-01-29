//
//  WeakScriptMessageDelegate.h
//  CloudPush
//
//  Created by YouMeng on 2017/5/15.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


// 创建此文件是为了解决WeakScriptMessageDelegate 释放问题的 简书 http://www.jianshu.com/p/6ba2507445e4


@interface WeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
