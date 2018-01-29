//
//  YMPartnerController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMPartnerController.h"
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


@protocol JSObjcDelegate <JSExport,ImageDownloadDelegate>


-(void)needLogin:(NSString* )loginString;
-(void)needRegister:(NSString* )registString;

-(void)needShare:(NSString* )shareString;

-(void)redirectSiteIndex;

@end

@interface YMPartnerController ()<UIWebViewDelegate,JSObjcDelegate>
{
    UIImageView *navBarHairlineImageView;
}
@property (nonatomic, strong) JSContext *jsContext;
@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条

//是否刷新登录状态
@property(nonatomic,assign)BOOL isLoginStatusChanged;

//去掉导航
//@property(nonatomic,strong)UIImageView* barImageView;
@end

@implementation YMPartnerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    //如果你导入的MJRefresh库是最新的库，就用下面的方法创建下拉刷新和上拉加载事件
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWebView)];
    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
    DDLog(@"web == %@",self.urlStr);
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];

    self.webView.userInteractionEnabled = YES;
    
    //背景色
    self.webView.backgroundColor = ClearColor;
    self.webView.opaque = NO;//这句话很重要，webView是否是不透明的，no为透明 在webView下添加个imageView展示图片就可以了
    //处理导航 透明问题
//    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
//    _barImageView.alpha = 0;
}
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //再定义一个imageview来等同于这个黑线
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
//    if (_barImageView ) {
//        _barImageView = self.navigationController.navigationBar.subviews.firstObject;
//        _barImageView.alpha = 0;
//    }
  //  if (self.isLoginStatusChanged != [kUserDefaults boolForKey:kisRefresh]) {
        self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
        self.isLoginStatusChanged = [kUserDefaults boolForKey:kisRefresh];
  //  }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    //恢复之前的导航色
    // _barImageView.alpha = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_LoginStatusChanged object:nil];
    [self.progressLayer closeTimer];
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer = nil;
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

//-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
//    //   ActivityVC * vc = [ActivityVC DefaultActivityView];
//    // [vc startActivityIndicatorView:self.view withTag:1000];
//  //  这里是我自己封装的方法。你自己加活动指示器就行
//}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    DDLog(@"request == %@",request);
    //显示网页加载状态
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressLayer startLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.progressLayer finishedLoad];
    [self endRefresh];
    //停止刷新转圈
    [self performSelector:@selector(stopAcVC) withObject:nil afterDelay:0];
    //self.whiteImgView.hidden = NO;
}
-(void)stopAcVC{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    //   ActivityVC * vc = [ActivityVC DefaultActivityView];
    // [vc stopActivityIndicatorView:self.view withTag:1000];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progressLayer finishedLoad];
    [self endRefresh];
    
    [self performSelector:@selector(stopAcVC) withObject:nil afterDelay:1.5];
#warning 处理空白页
    // WebView放到最上层
    [self.view bringSubviewToFront:self.webView];
    
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
    self.jsContext[@"needLogin"] = ^()
    {
        DDLog(@"needLogin");
    };
    self.jsContext[@"redirectSiteIndex"] = ^(){
        
    };
}

#pragma mark - 结束下拉刷新和上拉加载
- (void)endRefresh{
    //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    [self.webView.scrollView.mj_header endRefreshing];
   // [self.webView.scrollView.mj_footer endRefreshing];
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
            //[self.webView reload];
            
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
//            
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
            // [msgbox release];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
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

#pragma mark - JSExportDelegate
-(void)redirectSiteIndex{
    DDLog(@"合伙人跳转");
}

//-(void)userLoginStatusChanged:(NSNotification* )notification{
//    DDLog(@"用户状态改变了");
//    self.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",InviteFriendsURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
//    
//}

@end
