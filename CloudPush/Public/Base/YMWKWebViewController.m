//
//  YMWKWebViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWKWebViewController.h"
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


@protocol JSObjcDelegate <JSExport,ImageDownloadDelegate,WKScriptMessageHandler>

-(void)needLogin:(NSString* )loginString;
-(void)needRegister:(NSString* )registString;

-(void)needShare:(NSString* )shareString;

-(void)redirectSiteIndex;

@end

@interface YMWKWebViewController ()<JSObjcDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

// 网页交互 webView
@property(nonatomic,strong)IMYWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条
//是否刷新登录状态
@property(nonatomic,assign)BOOL isLoginStatusChanged;

//WKUserContentController  用户交互协议
@property(nonatomic,strong)WKUserContentController* userContentController;

@end

@implementation YMWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];

    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    // self.webView = [[IMYWebView alloc]initWithFrame:self.view.frame usingUIWebView:NO];
    // [self.view addSubview:_webView];
    
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    DDLog(@"web == %@",self.urlStr);
    //self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    //重点(当然需要遵守协议，不然会有警告)（当然遵守了这个你就可以侧滑返回上个页面了）
   // self.webView.navigationDelegate = self;
    //滑动返回看这里
   // self.webView.allowsBackForwardNavigationGestures = NO;

  //  self.webView.scalesPageToFit = YES;
  //  self.webView.delegate = self;

//    self.webView.userInteractionEnabled = YES;
    
}

#pragma mark - webView
-(IMYWebView *)webView{
    if (!_webView) {
        _webView = [[IMYWebView alloc]initWithFrame:self.view.frame usingUIWebView:NO];
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];//先实例化配置类 以前UIWebView的属性有的放到了这里
        //注册供js调用的方法
        _userContentController = [[WKUserContentController alloc]init];
       
        configuration.userContentController = _userContentController;
        configuration.preferences.javaScriptEnabled = YES;//打开js交互
        
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        
        WKWebView *webV = (WKWebView*)_webView;
        webV.navigationDelegate = self;
        webV.UIDelegate = self;
        webV.allowsBackForwardNavigationGestures =YES;//打开网页间的 滑动返回
        webV.allowsLinkPreview = YES;//允许预览链接
        
        self.userContentController =  webV.configuration.userContentController;
        [self.userContentController addScriptMessageHandler:self name:@"needShare"];
        [self.userContentController addScriptMessageHandler:self name:@"needRegister"];
        [self.userContentController addScriptMessageHandler:self name:@"needLogin"];
        [self.userContentController addScriptMessageHandler:self name:@"redirectSiteIndex"];
        
        //如果你导入的MJRefresh库是最新的库，就用下面的方法创建下拉刷新和上拉加载事件
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWebView)];
        [self.view addSubview:_webView];

//         _webView.navigationDelegate = self;
//        _webView.allowsBackForwardNavigationGestures = YES;//打开网页间的 滑动返回
//        _webView.allowsLinkPreview = YES;//允许预览链接
    }
    return _webView;
}
///WKWebView 跟网页进行交互的方法。
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name{
    DDLog(@"name == %@",name);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //  if (self.isLoginStatusChanged != [kUserDefaults boolForKey:kisRefresh]) {
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    //  }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_LoginStatusChanged object:nil];
    [self.progressLayer closeTimer];
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer = nil;
}

#pragma mark - WKNavigationDelegate 新增的几个代理
//// 这个方法是服务器重定向时调用，即 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//}
//// 在发送请求之前，决定是否跳转 ----- 会闪退 ？？？
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSURL *url = navigationAction.request.URL;
//    NSString *urlString = (url) ? url.absoluteString : @"";
//    // iTunes: App Store link
//    if ([urlString isMatch:RX(@"\\/\\/itunes\\.apple\\.com\\/")]) {
//        [[UIApplication sharedApplication] openURL:url];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    // Protocol/URL-Scheme without http(s)
//    else if (![urlString isMatch:[@"^https?:\\/\\/." toRxIgnoreCase:YES]]) {
//        [[UIApplication sharedApplication] openURL:url];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);

//    //需执行decisionHandler的block。
//    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
//    if (!navigationAction.targetFrame) {
//        NSURL *url = navigationAction.request.URL;
//        UIApplication *app = [UIApplication sharedApplication];
//        if ([app canOpenURL:url]) {
//            [app openURL:url];
//        }
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

#pragma mark - IMYWebViewDelegate
- (void)webViewDidStartLoad:(IMYWebView*)webView{
     [self.progressLayer startLoad];
}
- (void)webViewDidFinishLoad:(IMYWebView*)webView{
    [self.progressLayer finishedLoad];
    [self endRefresh];
    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = documentHeight + [UIScreen mainScreen].bounds.size.height-58 /*显示不全*/;
        frame.size.width  = SCREEN_WIDTH;
        webView.frame = frame;
    }];
    //    WKWebView *webV = (WKWebView*)self.webView;
    //    self.userContentController =  webV.configuration.userContentController;
    //    [self.userContentController addScriptMessageHandler:self name:@"needShare"];
    //    [self.userContentController addScriptMessageHandler:self name:@"needRegister"];
    //    [self.userContentController addScriptMessageHandler:self name:@"needLogin"];
    //    [self.userContentController addScriptMessageHandler:self name:@"redirectSiteIndex"];
  
    // self.whiteImgView.hidden = YES;
    //获取webview中scrovllview的contentsize进行设置  方法一
//    CGFloat webViewHeight  =  [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];// document.body.offsetHeight  方法二 三
//    // [webView.scrollView contentSize].height;
//  方法四
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeight;
//    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
//    CGRect newFrame    = webView.frame;
//    newFrame.size.height = actualSize.height;
//    newFrame.size.width  = actualSize.width;
//
//    webView.frame = newFrame;
#warning 处理空白页
    // WebView放到最上层
    // [self.view bringSubviewToFront:self.webView];
    
//    CGFloat webHeigh = 0.0f;
//    if (webView.subviews.count > 0) {
//        UIView* scrollView = webView.subviews[0];
//        if (scrollView.subviews.count > 0) {
//            UIView* webDocView = scrollView.subviews.lastObject;
//            if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
//                webHeigh = webDocView.frame.size.height;//获取文档的高度
//                webView.frame = webDocView.frame;
//            }
//        }
//    }
#warning todo  -  WKWebView  js交互
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
//    self.jsContext[@"EnjoyaLot"] = self;
//    // 以 JSExport 协议关联 native 的方法
//    // YMWeakSelf;
//    // 以 block 形式关联 JavaScript function  分享
//    self.jsContext[@"needShare"] = ^(NSString* shareStr)
//    {
//        NSArray *args = [JSContext currentArguments];
//        for (id obj in args) {
//            DDLog(@"%@  shareStr == %@",obj,shareStr);
//        }
//    };
//    //注册
//    self.jsContext[@"needRegister"] = ^()
//    {
//        DDLog(@"needRegister");
//    };
//    //登录
//    self.jsContext[@"needLogin"] = ^()
//    {
//        DDLog(@"needLogin");
//    };
//    //重新分配 地点 营地 siteIndex 跳转
//    self.jsContext[@"redirectSiteIndex"] = ^(){
//        
//    };

}
- (void)webView:(IMYWebView*)webView didFailLoadWithError:(NSError*)error{
    [self.progressLayer finishedLoad];
    [self endRefresh];
}
- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
     return YES;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.progressLayer startLoad];
}
// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressLayer finishedLoad];
    [self endRefresh];
    // self.whiteImgView.hidden = YES;
    //获取webview中scrovllview的contentsize进行设置  方法一

    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = documentHeight + [UIScreen mainScreen].bounds.size.height-58 /*显示不全*/;
        frame.size.width  = SCREEN_WIDTH;
        webView.frame = frame;
    }];
#warning 处理空白页
    //JS调用OC 添加处理脚本
//    [self.userContentController addScriptMessageHandler:self name:@"needShare"];
//    [self.userContentController addScriptMessageHandler:self name:@"needRegister"];
//    [self.userContentController addScriptMessageHandler:self name:@"needLogin"];
//    [self.userContentController addScriptMessageHandler:self name:@"redirectSiteIndex"];
    // WebView放到最上层
   // [self.view bringSubviewToFront:self.webView];
    
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
//    self.jsContext[@"EnjoyaLot"] = self;
//    // 以 JSExport 协议关联 native 的方法
//    // YMWeakSelf;
//    // 以 block 形式关联 JavaScript function  分享
//    self.jsContext[@"needShare"] = ^(NSString* shareStr)
//    {
//        NSArray *args = [JSContext currentArguments];
//        for (id obj in args) {
//            DDLog(@"%@  shareStr == %@",obj,shareStr);
//        }
//    };
//    //注册
//    self.jsContext[@"needRegister"] = ^()
//    {
//        DDLog(@"needRegister");
//    };
//    //登录
//    self.jsContext[@"needLogin"] = ^()
//    {
//        DDLog(@"needLogin");
//    };
    
//    //重新分配 地点 营地 siteIndex 跳转
//    self.jsContext[@"redirectSiteIndex"] = ^(){
//        
//    };
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self.progressLayer finishedLoad];
    [self endRefresh];
    //self.whiteImgView.hidden = NO;
}

#pragma mark - WKUIDelegate
/// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
     return nil;
}

//剩下三个代理方法全都是与界面弹出提示框相关的，针对于web界面的三种提示框
/**
 *  web界面中有弹出警告框时调用
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler {
    
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void(^)(void))completionHandler {
    if(_webView) {/*UIViewController of WKWebView has finish push or present animation*/
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    if(_webView )///*UIViewController of WKWebView is visible*/
        [self presentViewController:alertController animated:YES completion:^{}];
    else completionHandler();
}
#pragma mark - WKScriptMessageHandler  协议中包含一个必须实现的方法，这个方法是native与web端交互的关键，它可以直接将接收到的JS脚本转为OC或Swift对象
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    DDLog(@"message.body ==%@",message.body);
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
#pragma mark - UI界面设置
//设置返回按钮
-(void)setLeftBackButton{
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = BackGroundColor;
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//刷新界面
-(void)reloadWebView{
    // [self.webView reload];
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self endRefresh];
}

#pragma mark - 结束下拉刷新和上拉加载
- (void)endRefresh{
    //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    [self.webView.scrollView.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - JS  交互
-(void)needLogin:(NSString* )loginString{
    dispatch_async(dispatch_get_main_queue(), ^{
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        DDLog(@"登录");
        YMWeakSelf;
        lvc.refreshWebBlock = ^{
            weakSelf.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
        };
        [self presentViewController:nav animated:YES completion:nil];
    });
}
-(void)needRegister:(NSString* )registString{
    dispatch_async(dispatch_get_main_queue(), ^{
        YMRegistViewController* lvc = [[YMRegistViewController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.title = @"注册";
        lvc.isPresent = YES;
        DDLog(@"登录");
        [self presentViewController:nav animated:YES completion:nil];
    });
}
//分享给好友
-(void)needShare:(NSString* )shareString{
    DDLog(@"分享给好友 block = %@",shareString);
    if (![TencentOAuth iphoneQQInstalled] && ![WXApi isWXAppInstalled]) {
        DDLog(@"将要进行界面跳转由h5界面跳转到原生界面");
        //必须放入主线程中更新UI否则会出错
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD showFail:@"您的手机还未安装QQ客户端、微信！暂不能分享！" view:self.view];
//            UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的手机还未安装微信、QQ客户端！" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alerC addAction:sureAction];
//            [self presentViewController:alerC animated:YES completion:nil];
        });
        return;
    }
    NSArray* argArr =  [JSContext currentArguments];
    NSMutableArray* strArr = [[NSMutableArray alloc]init];
    for (JSValue* jsValue in argArr) {
        if ([[JSValue valueWithObject:jsValue inContext:self.jsContext] toObject]) {
            [strArr addObject:[[JSValue valueWithObject:jsValue inContext:self.jsContext] toObject]];
        }
    }
    NSString* urlStr;
    NSString* title;
    NSString* content ;
    for (int i = 0 ; i < strArr.count; i ++) {
        switch (i) {
            case 0:
                urlStr = strArr[0];
                break;
            case 1:
                title = strArr[1];
                break;
            case 2:
                content = strArr[2];
                break;
            default:
                break;
        }
    }
    DDLog(@" argArr == %@ urlStr == %@ title == %@ content == %@",argArr,urlStr,title,content);
    [self shareLinkToFriendsWithUrlStr:urlStr title:title content:content iconStr:shareLogoURL];
}
//实现协议方法(获取参数)
- (void)imageDownloadDidfinishDownloadImage:(UIImage *)image{
    DDLog(@"获取图片了  == %@",image);
}
#pragma mark - 分享链接
-(void)shareLinkToFriendsWithUrlStr:(NSString* )urlStr title:(NSString* )title content:(NSString* )content iconStr:(NSString* )iconStr{
    [[YMShareManager sharedManager] removeAllArr];
    NSArray *titles = [[YMShareManager sharedManager]titlesArrWithIsWXAppInstalled:[WXApi isWXAppInstalled] wxShowCount:2 isQQInstalled:[TencentOAuth iphoneQQInstalled] qqShowCount:2];
    NSArray *imageNames = [[YMShareManager sharedManager]imgsArrWithIsWXAppInstalled:[WXApi isWXAppInstalled] wxShowCount:2 isQQInstalled:[TencentOAuth iphoneQQInstalled] qqShowCount:2];
    DDLog(@"分享 titls == %@ images == %@",titles,imageNames);
    YMWeakSelf;
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    [sheet showActionSheetWithClickBlock:^(HLActionSheetItem* item,int btnIndex) {
        
        [weakSelf shareTypeWithItem:item index:btnIndex urlStr:urlStr title:title content:content iconStr:iconStr];
        
    } cancelBlock:^{
        
    }];
}
-(void)shareTypeWithItem:(HLActionSheetItem*)item index:(int)index urlStr:(NSString* )urlStr title:(NSString* )title content:(NSString* )content iconStr:(NSString* )iconStr{
    if ([item.titleLabel.text isEqualToString:@"QQ"]) {
        [[YMShareManager sharedManager] shareToQQWithIsShareToQZone:NO urlStr:urlStr title:title description:content previewImageURL:iconStr appId:QQ_AppId delegate:self viewController:self handBlock:^(QQApiSendResultCode send) {
            [self handleSendResult:send];
            DDLog(@"send == %d",send);
        }];
    }//QQ 空间
    else if ([item.titleLabel.text isEqualToString:@"空间"]) {
        [[YMShareManager sharedManager] shareToQQWithIsShareToQZone:YES urlStr:urlStr title:title description:content previewImageURL:iconStr appId:QQ_AppId delegate:self viewController:self handBlock:^(QQApiSendResultCode send) {
            
            [self handleSendResult:send];
            DDLog(@"send == %d",send);
        }];
        
    }//绑定微信。-- 朋友圈
    else if ([item.titleLabel.text isEqualToString:@"微信"]) {
        //微信授权
        [ImageDownloader downloadImageWithURL:shareLogoURL block:^(UIImage *image) {
            [[YMShareManager sharedManager]shareToWechatWithScene:WXSceneSession imgage:image title:title description:content webpageUrl:urlStr mediaTag:nil messageExt:nil messageAction:nil];
        }];
    }else if( [item.titleLabel.text isEqualToString:@"朋友圈"]){
        [ImageDownloader downloadImageWithURL:shareLogoURL block:^(UIImage *image) {
            [[YMShareManager sharedManager]shareToWechatWithScene:WXSceneTimeline imgage:image title:title description:content webpageUrl:urlStr mediaTag:nil messageExt:nil messageAction:nil];
        }];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - JSExportDelegate
-(void)redirectSiteIndex{
    DDLog(@"合伙人跳转");
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

@end
