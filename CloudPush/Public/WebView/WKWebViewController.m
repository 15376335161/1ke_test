 //
//  WKWebViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/5/15.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "YMWebProgressLayer.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Photos/Photos.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "HLActionSheet.h"
#import "YMShareManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXMediaMessage+messageConstruct.h"
#import "YMRegistViewController.h"
#import "NSString+Catogory.h"
#import "ImageDownloader.h"
#import "IMYWebView.h"
#import "RegExCategories.h"
//此文件解决内存泄漏问题
#import "WeakScriptMessageDelegate.h"



@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView* myWebView;
@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条

//是否刷新登录状态
@property(nonatomic,assign)BOOL isLoginStatusChanged;
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    // 进度条
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    //浏览器配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象Native，
    //JS在调用OC注册方法的时候要用下面的方式：window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
    //name(方法名)是放在中间的，messageBody只能是一个对象，如果要传多个值，需要封装成数组，或者字典。
    // 声明WKScriptMessageHandler 协议  另外创建一个代理对象，然后通过代理对象回调指定的self
    [config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"EnjoyaLot"];//
    
    self.myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.myWebView.UIDelegate = self;
    self.myWebView.navigationDelegate = self;
    [self.view addSubview:self.myWebView];
    
    
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    DDLog(@"web == %@",self.urlStr);
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    //如果你导入的MJRefresh库是最新的库，就用下面的方法创建下拉刷新和上拉加载事件
    _myWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWebView)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //  if (self.isLoginStatusChanged != [kUserDefaults boolForKey:kisRefresh]) {
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    //  }
}

//运行代码，self释放了，WeakScriptMessageDelegate却没有释放啊啊啊！
//还需在self的dealloc里面 添加这样一句代码
-(void)dealloc{
    DDLog(@"内存释放啦");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_LoginStatusChanged object:nil];
    [self.progressLayer closeTimer];
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer = nil;
    //解决内存泄漏问题
    [[_myWebView configuration].userContentController removeScriptMessageHandlerForName:@"EnjoyaLot"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UI界面设置
//刷新界面
-(void)reloadWebView{
    // [self.webView reload];
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self endRefresh];
}

#pragma mark - WKScriptMessageHandler  协议中包含一个必须实现的方法，这个方法是native与web端交互的关键，它可以直接将接收到的JS脚本转为OC或Swift对象
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    DDLog(@"message.body ==  %@",message.body);
    if(message.name == nil || [message.name isEqualToString:@""])
        return;
    //message body : js 传过来值
    if ([message.name isEqualToString:@"needLogin"])
    {
        [self needLogin:nil];
    }
    else if ([message.name isEqualToString:@"needRegister"])
    {
        [self needRegister:nil];
    }
    //进入详情页
    else if ([message.name isEqualToString:@"needShare"])
    {
        [self needShare:nil];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //显示网页加载状态
    [self.progressLayer startLoad];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    DDLog(@"开始加载网页啦");
}
// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    DDLog(@"开始回调内容啦");
}
// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressLayer finishedLoad];
    [self endRefresh];
    [self performSelector:@selector(stopAcVC) withObject:nil afterDelay:0];
    DDLog(@"界面内容啦加载完成啦");
    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = documentHeight + [UIScreen mainScreen].bounds.size.height-58 /*显示不全*/;
        frame.size.width  = SCREEN_WIDTH;
        webView.frame = frame;
    }];
#warning 处理空白页
    // WebView放到最上层
    // [self.view bringSubviewToFront:self.webView];
    DDLog(@"wkwebView 页面加载完成");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self.progressLayer finishedLoad];
    [self endRefresh];
    //停止刷新转圈
    [self performSelector:@selector(stopAcVC) withObject:nil afterDelay:0];
    //self.whiteImgView.hidden = NO;
}
-(void)stopAcVC{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
#pragma mark - WKUIDelegate
//但是新开一个webView。如果我们只是显示网页，就感觉这么做耗性能，没有必要。
//可以指定配置对象、导航动作对象、window特性。如果没有 实现这个方法，不会加载链接，如果返回的是原webview会崩溃
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// webview关闭时回调
- (void)webViewDidClose:(WKWebView *)webView {
    
}
//剩下三个代理方法全都是与界面弹出提示框相关的，针对于web界面的三种提示框
/**
 *  web界面中有弹出警告框时调用
 *  @param completionHandler 警告框消失调用
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    DDLog(@"执行js");
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler {
    
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    [[[UIAlertView alloc] initWithTitle:@"输入框" message:prompt delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] show];
    completionHandler(@"你是谁！");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    [[[UIAlertView alloc] initWithTitle:@"确认框" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] show];
    completionHandler(1);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void(^)(void))completionHandler {
    if(_myWebView) {
        /*UIViewController of WKWebView has finish push or present animation*/
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    if(_myWebView )
        /*UIViewController of WKWebView is visible*/
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    else completionHandler();
}
#pragma mark - UI
-(void)endRefresh{
    //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    [self.myWebView.scrollView.mj_header endRefreshing];
}

//-(WKWebView *)webView{
//    if (!_webView) {
//        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//        wkWebConfig.preferences.minimumFontSize = 18;
//        // 自适应屏幕宽度js
//        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        // 添加自适应屏幕宽度js调用的方法
//        self.userContentController = [[WKUserContentController alloc]init];
//        [self.userContentController addUserScript:wkUserScript];
//
//        wkWebConfig.userContentController = self.userContentController;
//       // 实例化
//        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT - NavBarTotalHeight - TabBarHeigh) configuration:wkWebConfig];
//
//        [self.view addSubview:_webView];
//    }
//    return _webView;
//}
#warning todo --- 要实现，否则会闪退
//#pragma mark - 页面跳转的代理方法
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//}
//// 在发送请求之前，决定是否跳转
//WKNavigationDelegate中的该方法是用户点击网页上的链接，需打开新页面时，将先调，是否允许跳转到链接
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//    WKFrameInfo *sFrame = navigationAction.sourceFrame;//navigationAction的出处
//    WKFrameInfo *tFrame = navigationAction.targetFrame;//navigationAction的目标
//    //只有当  tFrame.mainFrame == NO；时，表明这个 WKNavigationAction 将会新开一个页面。
//    //才会调用- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;

//决定导航的 是否跳转到下载界面
    //NSURL *url = navigationAction.request.URL;
    //NSString *urlString = (url) ? url.absoluteString : @"";
    //// iTunes: App Store link
    //if ([urlString isMatch:RX(@"\\/\\/itunes\\.apple\\.com\\/")]) {
    //    [[UIApplication sharedApplication] openURL:url];
    //    decisionHandler(WKNavigationActionPolicyCancel);
    //    return;
    //}
    //// Protocol/URL-Scheme without http(s)
    //else if (![urlString isMatch:[@"^https?:\\/\\/." toRxIgnoreCase:YES]]) {
    //    [[UIApplication sharedApplication] openURL:url];
    //    decisionHandler(WKNavigationActionPolicyCancel);
    //    return;
    //}
    //decisionHandler(WKNavigationActionPolicyAllow);
    //
    ////需执行decisionHandler的block。
    ////this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
    //if (!navigationAction.targetFrame) {
    //    NSURL *url = navigationAction.request.URL;
    //    UIApplication *app = [UIApplication sharedApplication];
    //    if ([app canOpenURL:url]) {
    //        [app openURL:url];
    //    }
    //}
    //decisionHandler(WKNavigationActionPolicyAllow);
//}

#pragma mark - JS 交互 --  交互需要将 改变后台交互代码的形式
-(void)needLogin:(NSString*)param{
    DDLog(@"需要登录");
}

-(void)needRegister:(NSString*)param{
    DDLog(@"需要登录");
}

-(void)needShare:(NSString*)param{
    DDLog(@"需要登录");
}


@end
