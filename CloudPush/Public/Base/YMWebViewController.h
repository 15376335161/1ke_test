//
//  YMWebViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "YMWebProgressLayer.h"


/*
*  此类是 webView 的基类，包含有 webView  进度条 等 基础控件功能等
*/
 
@interface YMWebViewController : BaseViewController


@property(nonatomic,copy)void(^agreeBlock)(NSString* isAgree);

//xib 子类不能继承，改成了纯代码 创建了
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条
//网页链接
@property(nonatomic,copy)NSString* urlStr;


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewDidStartLoad:(UIWebView *)webView;

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
