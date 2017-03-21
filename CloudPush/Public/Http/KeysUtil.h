//
//  KeysUtil.h
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef KeysUtil_h
#define KeysUtil_h

typedef NS_ENUM(NSInteger, CustomTypeStatus) {
   // CustomTypeStatusUP     = -1,
    CustomTypeStatusUP     =  0,
    CustomTypeStatusDown   =  1
    
};

typedef NS_ENUM(NSInteger, TaskTypeStatus) {
    TaskTypeStatusWait         = 0,
    TaskTypeStatusChecking     = 1,
    TaskTypeStatusDone         = 2,
    TaskTypeStatusInvalid      = 3
};

typedef NS_ENUM(NSInteger,SetType) {
    SetTypePayWordUnSet       = 0,
    SetTypePayWordModify,//设置支付密码
    SetTypePayWordUnSetTwice,//设置支付密码 第二步
    
    SetTypeZhiFuBaoUnSet,//设置支付宝账户
    SetTypeZhiFuBaoModify,//修改支付宝账户 第一步
    SetTypeZhiFuBaoModifyTwice,//修改支付宝账户 第二步
    
    SetTypeBankCardUnSet,//设置银联卡账户
    SetTypeBankCardModify

};

typedef NS_ENUM(NSInteger,WithDrawCrashStyle) {
    WithDrawCrashStyleZfb       = 0,// 提现方式支付宝
    WithDrawCrashStyleBankCard      // 提现方式 银行卡
};


#define kJPushAppKey    @"a4e14f9c3a2ff72f5a400b3e"
#define kChannel        @"appStore"
#define kIsProduct      YES

#define kFirstOpen   @"firstOpen"
#define kAutoLogin   @"kAutoLogin"


#define WeChat_AppId      @"wxdcc23700247f2571"  // wx1705d06974c1200e//wxd930ea5d5a258f4f
#define WeChatAppSecrect  @"1851a8f91573e7e32700b88b1f1b2832"
//#define WeChat_Secret   @"tiaoshi@86goodfood.com"

#define QQ_AppId        @"1105935609"         //  @"1105155505"
#define QQ_Secrect      @"bUfLXNbJWYH5PgLf"   // @"KYJZQznciNcbiAs4"



#define kNotification_Login     @"kNotificationLogin"
#define kNotification_LoginOut  @"kNotificationLoginOut"
#define kNotification_LoginStatusChanged  @"kNotificationLoginStatusChanged"
#define kUserDefaults         [NSUserDefaults standardUserDefaults]


//系统的颜色
#define BlackColor      [UIColor blackColor]
#define WhiteColor      [UIColor whiteColor]
#define RedColor        [UIColor redColor]
#define BlueColor       [UIColor blueColor]
#define OrangeColor     [UIColor orangeColor]
#define LightGrayColor  [UIColor lightGrayColor]
#define LightTextColor  [UIColor lightTextColor]
#define ClearColor      [UIColor clearColor]
//背景色
#define BackGroundColor       HEX(@"F0F0F0")// RGBA(239, 239, 244, 1)
#define NavBarTintColor       HEX(@"2196F3")//RGBA(90, 162, 238, 1)

//不可点击颜色
#define NavBar_UnabelColor    RGBA(90, 162, 238, 0.5)

//传入RGB三个参数，得到颜色
#define RGB(r,g,b) RGBA(r,g,b,1.f)
//那我们就让美工给出的 参数/255 得到一个0-1之间的数
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEX(a)         [UIColor colorwithHexString:[NSString stringWithFormat:@"%@",a]]

//取得随机颜色
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)
//字体大小
#define Font(a)        [UIFont systemFontOfSize:a]

//屏幕宽度
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEGIHT  ([UIScreen mainScreen].bounds.size.height)
//获取屏幕大小
#define kScreenSize [UIScreen mainScreen].bounds.size

#define NavBarHeight      44
#define StatusHeight      20
#define NavBarTotalHeight 64
#define TabBarHeigh       48
#define TitleViewHeigh    40

#define kSessionCookie      @"sessionCookies"
#define kUserDefaults            [NSUserDefaults standardUserDefaults]
#define kYMUserInstance          [YMUserManager shareInstance]
#define kWidthRate               SCREEN_WIDTH / 375

//用户相关的key
#define kPhone       @"phone"
#define kToken       @"token"
#define kUid         @"uid"
#define kUsername    @"username"
#define kDate        @"date"
#define kZfb_realName        @"zfb_realName"
#define kZfb_accountName     @"zfb_accountName"
#define kCard_realName       @"isCard_realName"
#define kCard_accountName    @"isCard_accountName"


#define kPasswd      @"passwd"

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";//授权域
//static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState = @"xxx";

//7.0以上的系统
#define IOS7      ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)
//ios 7 一下的系统
#define IOS_7    ([UIDevice currentDevice].systemVersion.doubleValue < 7.0)

#endif /* KeysUtil_h */
