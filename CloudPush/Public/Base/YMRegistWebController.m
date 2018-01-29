//
//  YMRegistWebController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMRegistWebController.h"


@interface YMRegistWebController ()<UIWebViewDelegate>

@end


@implementation YMRegistWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];

   // 加载界面
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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
