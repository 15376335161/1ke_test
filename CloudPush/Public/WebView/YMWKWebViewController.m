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
#import "WeakScriptMessageDelegate.h"

#import "RegExCategories.h"

//IMYWebView
@protocol JSObjcDelegate <JSExport,ImageDownloadDelegate,WKScriptMessageHandler>

-(void)needLogin:(NSString* )loginString;
-(void)needRegister:(NSString* )registString;

-(void)needShare:(NSString* )shareString;

-(void)redirectSiteIndex;

@end

@interface YMWKWebViewController ()<JSObjcDelegate,IMYWebViewDelegate>

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
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    
#endif
    self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    //进度条
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
   
    [self.view addSubview:self.webView];
    
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    DDLog(@"web == %@",self.urlStr);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
     // 重点(当然需要遵守协议，不然会有警告)（当然遵守了这个你就可以侧滑返回上个页面了）
     //self.webView.navigationDelegate = self;
     //滑动返回看这里
     // self.webView.allowsBackForwardNavigationGestures = NO;
     self.webView.scalesPageToFit = YES;
     self.webView.delegate = self;
     self.webView.userInteractionEnabled = YES;
    
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
    //解决内存泄漏问题
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        WKWebView* wkWebView = (WKWebView*)_webView;
         [wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"EnjoyaLot"];
    }
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
//刷新界面
-(void)reloadWebView{
    // [self.webView reload];
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self endRefresh];
}
-(IMYWebView *)webView{
    if (!_webView) {
        _webView = [[IMYWebView alloc]initWithFrame:self.view.frame usingUIWebView:NO];
//        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
//        //先实例化配置类 以前UIWebView的属性有的放到了这里
//        //注册供js调用的方法
//        _userContentController = [[WKUserContentController alloc]init];
//        configuration.userContentController = _userContentController;
//        configuration.preferences.javaScriptEnabled = YES;//打开js交互
        
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        // 注入JS对象Native，
        // 声明WKScriptMessageHandler 协议 iOS8下 本地注册js方法，让服务端调用
        [_webView addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"EnjoyaLot"];
        
        //如果你导入的MJRefresh库是最新的库，就用下面的方法创建下拉刷新和上拉加载事件
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWebView)];
        // [self.view addSubview:_webView];
    }
    return _webView;
}
#pragma mark - 结束下拉刷新和上拉加载
- (void)endRefresh{
    //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    [self.webView.scrollView.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
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
#warning 处理空白页
    // WebView放到最上层
     [self.view bringSubviewToFront:self.webView];
        CGFloat webHeigh = 0.0f;
        if (webView.subviews.count > 0) {
            UIView* scrollView = webView.subviews[0];
            if (scrollView.subviews.count > 0) {
                UIView* webDocView = scrollView.subviews.lastObject;
                if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
                    webHeigh = webDocView.frame.size.height;//获取文档的高度
                    webView.frame = webDocView.frame;
                }
            }
        }
}
- (void)webView:(IMYWebView*)webView didFailLoadWithError:(NSError*)error{
    [self.progressLayer finishedLoad];
    [self endRefresh];
}
- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

#pragma mark - js oc 交互
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

@end
