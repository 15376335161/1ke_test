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

//友盟统计
#import "UMMobClick/MobClick.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate,JPUSHRegisterDelegate,TCAPIRequestDelegate>

@end

@implementation AppDelegate
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;//默认的值是黑色的
}
- (BOOL)prefersStatusBarHidden
{
    return NO; // 是否隐藏状态栏
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    
        UMConfigInstance.appKey =  kUMAppKey;
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
    
//    //集成获取测试设备信息
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    DDLog(@"oid  =============== %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kChannel
                 apsForProduction:kIsProduct
            advertisingIdentifier:nil];
    
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
    [YSKeyboardMoving appearance].offset = 50;
    
//    DDLog(@"time == close ");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         DDLog(@"time == closed  haha ");
//        system("killall SpringBoard");
//       // kill();
//       // SYSTEM_CLOCK;
//        system("reboot");
//        //posix_spawn;
//    });
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
        [application setApplicationIconBadgeNumber:10];
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
#pragma mark - 联网状态监听
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

#pragma mark - 注册极光推送 上报 deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DDLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
//添加处理APNs通知回调方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    DDLog(@"response === %@",response);
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    DDLog(@"收到推送 userInfo == %@",userInfo);
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


@end
