//
//  BaseWebViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseWebViewController.h"
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
#import "ImageDownloader.h"
#import "UIView+Placeholder.h"

@protocol JSObjcDelegate <JSExport,ImageDownloadDelegate>

//登录
-(void)needLogin:(NSString* )loginString;
//注册
-(void)needRegister:(NSString* )registString;
//跳转分享
-(void)needShare:(NSString* )shareString;
//点击使用红包 会弹出立即使用按钮   点击按钮 会跳转到APP端首页
-(void)redirectSiteIndex;
//客服电话
-(void)callservice:(NSString* )tel;
//返回首页
-(void)returnHome;

@end

@interface NSURLRequest (InvalidSSLCertificate)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@interface BaseWebViewController ()<UIWebViewDelegate,JSObjcDelegate>
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) BOOL theBool;

@property (nonatomic, strong) JSContext *jsContext;

//空白页
@property(nonatomic,strong)UIView* placeView;

//改变登录状态
@property(nonatomic,assign)BOOL isLoginStatusChanged;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoginStatusChanged = [kUserDefaults valueForKey:kisRefresh];
    //添加左边的返回键
    [self addLeftButton];
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    //加载界面
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.isLoginStatusChanged != [kUserDefaults boolForKey:kisRefresh]) {
         //重新加载界面
        NSString* urlStr =  [NSString stringWithFormat:@"%@?uid=%@&platform_id=%@&ssotoken=%@",ProductDetailURL,[kUserDefaults valueForKey:kUid] ? [kUserDefaults valueForKey:kUid] : @"",self.platform_id,[kUserDefaults valueForKey:kToken] ? [kUserDefaults valueForKey:kToken] : @"" ];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
//        [self.webView reload];
        self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.backItem;
}
- (void)dealloc {
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    DDLog(@"i am dealloc");
}
#pragma mark - UI
//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"back"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 60);
        _backItem.customView = btn;
    }
    return _backItem;
}
- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        _closeItem.tintColor = WhiteColor;
    }
    return _closeItem;
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.view resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)placeView{
    if (!_placeView) {
        _placeView = [UIView placeViewWhithFrame:self.view.frame placeImgStr:@"badNet" placeString:@"您的手机网络不给力！"];
        [self.view addSubview:_placeView];
        _placeView.hidden = YES;
    }
    return _placeView;
}

//加载URL
- (void)loadHTML:(NSString *)htmlString
{
    NSURL *url = [NSURL URLWithString:htmlString];
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    DDLog(@"requestString == %@",requestString);
    if ([requestString rangeOfString:@"xxxx"].location != NSNotFound){
        //跳转页面方法
        return NO;
    }
    else{
        return YES;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_progressLayer startLoad];
}
//加载失败 添加 网页连接失败！
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
    DDLog(@"err == %@",error);
//    if ([YMTool isNetConnect] == NO) {
//        self.placeView.hidden = NO;
//    }
    
    NSURL *url = [NSURL URLWithString:[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]];
    if ([error.domain isEqual:@"WebKitErrorDomain"]
        && error.code == 101
        && [[UIApplication sharedApplication]canOpenURL:url])
    {
        [[UIApplication sharedApplication]openURL:url];
        return;
    }
    
    if (error.code == NSURLErrorCancelled)
        return;
    
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"])
        return;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_progressLayer finishedLoad];
    
    // self.placeView.hidden = YES;
    
    self.theBool = true; //加载完毕后，进度条完成
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    self.jsContext[@"EnjoyaLot"] = self;
    // 以 JSExport 协议关联 native 的方法
    
    // YMWeakSelf;
    // 以 block 形式关联 JavaScript function  分享
    self.jsContext[@"needShare"] = ^(NSString* shareStr)
    {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            DDLog(@"%@  shareStr == %@",obj,shareStr);
        }
    };
    //注册
    self.jsContext[@"needRegister"] = ^()
    {
        DDLog(@"needRegister");
    };
    //登录
    self.jsContext[@"needLogin"] = ^(){
        DDLog(@"needLogin");
    };
    self.jsContext[@"redirectSiteIndex"] = ^(){
        
    };
    self.jsContext[@"callservice"] = ^(NSString* tel){
        DDLog(@"打客服电话");
    };
    
    self.jsContext[@"returnHome"] = ^(){
        DDLog(@"返回首页");
    };
}

#pragma mark - JSExportDelegate
//登录
-(void)needLogin:(NSString* )loginString{
    dispatch_async(dispatch_get_main_queue(), ^{
        YMWeakSelf;
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.refreshWebBlock = ^(){
//            [weakSelf.webView reload];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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
//    YMRegistViewController* lvc = [[YMRegistViewController alloc]init];
//    YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
//    DDLog(@"登录");
//    lvc.title = @"注册";
//    [self presentViewController:nav animated:YES completion:nil];
}

    
//分享给好友
-(void)needShare:(NSString* )shareString{
    DDLog(@"分享给好友 block = %@",shareString);
    if (![TencentOAuth iphoneQQInstalled] && ![WXApi isWXAppInstalled]) {
//        NSString *jsMyAlert = @"setTimeout(function(){alert('FOOBAR');}, 1);";
//        
//        [self.webView stringByEvaluatingJavaScriptFromString:jsMyAlert];
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
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装手机QQ" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //  [msgbox release];
            
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
-(void)callservice:(NSString* )tel{
    DDLog(@"返现tel == %@",tel);
    NSString *allString = [NSString stringWithFormat:@"tel:%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

//声明一个协议,代理对象执行协议方法时讲参数传递过去
- (void)imageDownloadDidfinishDownloadImage:(UIImage *)image{
    DDLog(@"image == %@",image);
}
//返回首页
-(void)returnHome{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
