//
//  WeakScriptMessageDelegate.m
//  CloudPush
//
//  Created by YouMeng on 2017/5/15.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "WeakScriptMessageDelegate.h"

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}


@end
