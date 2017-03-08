//
//  YMWebViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWebViewController.h"
#import <WebKit/WebKit.h>

@interface YMWebViewController ()<WKUIDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation YMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载界面
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
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
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}


@end
