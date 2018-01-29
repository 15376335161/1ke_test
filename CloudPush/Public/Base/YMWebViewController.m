//
//  YMWebViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWebViewController.h"
#import <WebKit/WebKit.h>


/*
 *  此类是 webView 的基类，包含有 webView  进度条 等 基础控件功能等
 */

@interface YMWebViewController ()<WKUIDelegate,UIWebViewDelegate>

@end

@implementation YMWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    //加载界面
//    self.webView.delegate = self;
//    self.webView.userInteractionEnabled = YES;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT - NavBarTotalHeight)];
        [self.view addSubview:_webView];
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self;
    }
    return _webView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //同意用户协议
    if (self.agreeBlock) {
        self.agreeBlock(@"1");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
     DDLog(@"开始加载数据 request == %@",request);
    //http://passport.youmeng.com/reg/agrement
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    DDLog(@"开始加载数据");
     [_progressLayer startLoad];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_progressLayer finishedLoad];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}
- (void)dealloc {
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    DDLog(@"i am dealloc");
}

@end
