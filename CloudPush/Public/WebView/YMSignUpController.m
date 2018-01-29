//
//  YMSignUpController.m
//  CloudPush
//
//  Created by YouMeng on 2017/5/18.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSignUpController.h"
#import "YMTabBarController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YMRegistViewController.h"



@protocol JSObjcDelegate <JSExport>

-(void)needLogin:(NSString* )loginString;
-(void)needRegister:(NSString* )registString;
-(void)redirectSiteIndex;

@end

@interface YMSignUpController ()<UIWebViewDelegate,JSObjcDelegate>
@property (nonatomic, strong) JSContext *jsContext;


@property(nonatomic,assign)BOOL isLoginStatusChanged ;
@end

@implementation YMSignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    //设置返回按钮
    [self setLeftBackButton];
    //加载界面
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //点完登录 刷新界面 --  这里会有bug
    if (self.isLoginStatusChanged != [kUserDefaults boolForKey:kisRefresh]) {
        NSString* urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",UserSignListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    }
}
//设置返回按钮
-(void)setLeftBackButton{
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = BackGroundColor;
}
-(void)back{
    DDLog(@"设置返回按钮");
    if (self.isToTabBar) {
        YMTabBarController* tvc = [[YMTabBarController alloc]init];
        [self presentViewController:tvc animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DDLog(@"开始加载数据 request == %@",request);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    DDLog(@"开始加载数据");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //加载完毕后，进度条完成
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        DDLog(@"异常信息：%@", exceptionValue);
    };
    self.jsContext[@"EnjoyaLot"] = self;
    
    // 以 JSExport 协议关联 native 的方法
    // YMWeakSelf;
    // 以 block 形式关联 JavaScript function  分享
    
    self.jsContext[@"redirectSiteIndex"] = ^(){
        DDLog(@"参加活动");
    };
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DDLog(@"errror === %@",error);
}

#pragma mark - JSExportDelegate
-(void)redirectSiteIndex{
    dispatch_async(dispatch_get_main_queue(), ^{
        YMTabBarController* tvc = [[YMTabBarController alloc]init];
        [self presentViewController:tvc animated:YES completion:nil];
    });
}
#pragma mark - JSExportDelegate
//登录
-(void)needLogin:(NSString* )loginString{
    dispatch_async(dispatch_get_main_queue(), ^{
        YMWeakSelf;
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.refreshWebBlock = ^(){
            NSString* urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",UserSignListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        };
        DDLog(@"登录");
        [self presentViewController:nav animated:YES completion:nil];
    });
}
//注册
-(void)needRegister:(NSString* )registString{
    dispatch_async(dispatch_get_main_queue(), ^{
        YMRegistViewController* lvc = [[YMRegistViewController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        DDLog(@"登录");
        lvc.title = @"注册";
        [self presentViewController:nav animated:YES completion:nil];
    });
}

@end
