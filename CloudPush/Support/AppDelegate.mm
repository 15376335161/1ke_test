//
//  AppDelegate.m
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "AppDelegate.h"
#import "RealReachability.h"
#import "YMTool.h"
#import "YMTabBarController.h"
#import "YMWelcomeController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UIView+YSTextInputKeyboard.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
//红包列表 消息列表
#import "YMRedBagController.h"
#import "YMMsgListController.h"
#import <AVFoundation/AVFoundation.h>

//友盟统计
#import "UMMobClick/MobClick.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate,JPUSHRegisterDelegate,TCAPIRequestDelegate>

@end

@implementation AppDelegate

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    DDLog(@"收到消息推送通知 content == %@",content);
    
}
//如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apns 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //是否在前台
//    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:remoteNotification];
//    DDLog(@"remoteNotification == %@",remoteNotification);
//    //打开app 设置为 0
//     application.applicationIconBadgeNumber = 0;
//     [JPUSHService setBadge:0];
//     [JPUSHService resetBadge];
    //设置导航栏按钮的颜色
    [[UINavigationBar appearance]setTintColor:NavBarTintColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //监听网络情况
    [GLobalRealReachability startNotifier];
    if (![YMTool isNetConnect]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager* mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:kBaiduKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //微信支付
        //[WXApi registerApp:WeChat_AppId withDescription:@"云众推"];
        //向微信终端注册你的id
        [WXApi registerApp:WeChat_AppId];
        //向微信注册支持的文件类型
        UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
        [WXApi registerAppSupportContentFlag:typeFlag];
    
        UMConfigInstance.appKey    =  kUMAppKey;
        UMConfigInstance.ChannelId = @"App Store";
        [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
        //上报版本号
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        //设置 数据发送策略
        UMConfigInstance.ePolicy = BATCH;
        // 测试日志
        [MobClick setLogEnabled:YES];
    });
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//            JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//            entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
//            //自定义categories
////            NSSet<UNNotificationCategory *> *categories;
////            entity.categories = categories;
//            [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//#endif
//        }
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kChannel
                 apsForProduction:kIsProduct
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DDLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            DDLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    //实例主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL isOpen = [kUserDefaults boolForKey:kFirstOpen];
    //引导页 欢迎界面
    if (!isOpen) {
        self.window.rootViewController = [[YMWelcomeController alloc] init];
    }else{
        //若已登录
        YMTabBarController *homeVc = [[YMTabBarController alloc] init];
        self.window.rootViewController = homeVc;
    }
    //记录打开情况
    [kUserDefaults setBool:YES forKey:kFirstOpen];
    
    self.window.backgroundColor = WhiteColor;
    [self.window makeKeyAndVisible];
    //您可以统一设置键盘遮挡时的默认偏移值
    //[YSKeyboardMoving appearance].offset = 50;
    return YES;
}
#pragma mark - 处理回调 微信 或 QQ 等
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([sourceApplication isEqualToString:@"com.tencent.xin"] ||
       [sourceApplication isEqualToString:@"com.apple.MobileSMS"]){
        
        [WXApi handleOpenURL:url delegate:self];
        
    }else if([sourceApplication isEqualToString:@"com.tencent.mqq"] ){
        [TencentOAuth HandleOpenURL:url];
    }
    else if([[url scheme] isEqualToString:@"cloudPush://"]){
        [application setApplicationIconBadgeNumber:0];
         return YES;
    }
    return YES;
}

#pragma mark - WXApiDelegate
//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)req{
    DDLog(@"resp == %@",req);
    //消息
    if([req isKindOfClass:[GetMessageFromWXReq class]]){
        
    }else if([req isKindOfClass:[ShowMessageFromWXReq class]]){
        
    }else if([req isKindOfClass:[LaunchFromWXReq class]]){
        
    }
}

//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void) onResp:(BaseResp*)resp{
    DDLog(@"resp == %@",resp);
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
    }
}
#pragma mark --- app
- (void)applicationWillResignActive:(UIApplication *)application {
   
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}
- (void)applicationWillTerminate:(UIApplication *)application {
  
}

#pragma mark - 注册极光推送 上报 deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DDLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
#pragma mark -  点开会响应这个
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
    
    DDLog(@"notification == %@",userInfo);
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
        //在登录情况下跳转消息中心，未登录情况下跳转主页
        if ([[YMUserManager shareInstance] isValidLogin]) {
            [self pushToMsgListController];
        }else{
        }
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
        //在登录情况下跳转消息中心，未登录情况下跳转主页
       if ([[YMUserManager shareInstance] isValidLogin]) {
           [self pushToRedListController];
       }else{
       }
    }
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
    
    //ios10 收到消息通知
    NSDictionary * userInfo = notification.request.content.userInfo;
    DDLog(@"ios 10 收到推送 %@",userInfo);
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //本地通知
    else{
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置

    //如果应用在前台，在这里执行
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:notification.request.content.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil,nil];
    [alertView show];
    //播放语音
    // [self readMsgWithMessage:userInfo[@"aps"][@"alert"]];
}

//如果 App状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行
//基于iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];//小红点清0操作
    DDLog(@"ios7 收到消息推送 == %@",userInfo);
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //判断程序是否在前台运行
    if (application.applicationState == UIApplicationStateActive) {
        //如果应用在前台，在这里执行
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:content delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil,nil];
        [alertView show];
        
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        return;
    }
    DDLog(@"收到推送 userInfo == %@",userInfo);
    // iOS 7 Support Required,处理收到的APNS信息
    //如果应用在后台，在这里执行
    //ios10 收到消息通知
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
        [self pushToMsgListController];
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
        [self pushToRedListController];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    //播放语音
    // [self readMsgWithMessage:userInfo[@"aps"][@"alert"]];
    
}
#pragma mark - 收到消息跳转
-(void)pushToMsgListController{
    YMMsgListController* mvc = [[YMMsgListController alloc]init];
    mvc.title       = @"消息中心";
    YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:mvc];
    
    //window找到根控制器
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    DDLog(@"topRootViewController == %@",topRootViewController);
    if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
        mvc.isMsgPushed = YES;
        [topRootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [topRootViewController.navigationController pushViewController:nav animated:YES];
    }
    
}

-(void)pushToRedListController{
    YMRedBagController* mvc = [[YMRedBagController alloc]init];
    mvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",RedPaperListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]] ;
    YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:mvc];
    
    //window找到根控制器
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    DDLog(@"topRootViewController == %@",topRootViewController);
    if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
        mvc.isToTabBar = YES;
        mvc.title      = @"我的红包";
        [topRootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [topRootViewController.navigationController pushViewController:nav animated:YES];
    }
}
#pragma mark - 收到消息播放语音
-(void)readMsgWithMessage:(NSString* )msg{
    //语音播报文件
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:msg];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
    utterance.voice = voice;
    //    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    utterance.volume= 1;  //设置音量（0.0~1.0）默认为1.0
    utterance.rate= AVSpeechUtteranceDefaultSpeechRate;  //设置语速
    utterance.pitchMultiplier= 1;  //设置语调
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];

}
#pragma mark - 设置 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;//默认的值是黑色的
}
- (BOOL)prefersStatusBarHidden
{
    return NO; // 是否隐藏状态栏
}
#pragma mark - 百度地图  联网状态监听
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        DDLog(@"联网成功");
    }
    else{
        DDLog(@"onGetNetworkState %d",iError);
    }
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        DDLog(@"授权成功");
    }
    else {
        DDLog(@"onGetPermissionState %d",iError);
    }
}



@end
