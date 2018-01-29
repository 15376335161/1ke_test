//
//  URLs.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef URLs_h
#define URLs_h


#define SUCCESS         @"1"
#define FAILURE         @"0"
#define TOKEN_TIMEOUT   @"-999999"
#define FAILURE_TOKEN   @"API_FAILURE_TOKEN"

#define  BaseApi         @"http://apiyzt.youmeng.com/"  //@"http://192.168.10.31:8081/" //

//请求首页数据
#define HomeDataURL        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/home"]
////修改支付宝 支付密码 手机验证   注册 修改密码 快捷登录 修改手机发送给旧手机 修改手机发送给新手机
#define  SendMsgCodeURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/sms_interface/send"]
//修改 绑定 手机
#define UpdatePhoneURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/updatePhone"]
//注册协议
#define RegistProtocalURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Reg/agrement"]
//@"http://apiyzt.youmeng.com/Reg/agrement"
//关于我们
#define AboutUsURL              @"http://sdd.youmeng.com/about.html"

//忘密码 图形验证码
#define ForgetImgCodeCheckURL   @"http://passport.youmeng.com/find/checkfindcaptcha"
//找回密码获取验证码
#define ForgetSendCodeURL       @"http://passport.youmeng.com/find/sendphonecaptcha"
//忘记密码 短信验证
#define ForgetCheckPhoneURL     @"http://passport.youmeng.com/find/checkphonecaptcha"
//忘记密码 设置密码
#define ForgetSetPasswdURL      @"http://passport.youmeng.com/find/resetpasswd"

//注册
#define RegisterURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/register"] //@"http://apiyzt.youmeng.com/Api/Site/register"
//修改密码 密保手机  短信验证
#define ValidateMsgURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Sms_interface/validate"]
//修改密码
#define updatePasswordURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/updatePasswd"]

//分享logo 的链接
#define shareLogoURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"static/images/share_logo@2x.png"]

//上传头像
#define uploadUserPicURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/upload_pic_interface/upload"]
//提现明细
#define ExtractRecordListURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/ExtractRecord"]
//余额明细
#define ChangeMoneyLogURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/ChangeMoneyLog"]
//待发明细
#define WaitingListURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/WaitingList"]
//用户反馈 意见反馈接口
#define SuggestListURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/SuggestionList"]

//红包列表接口
#define RedPaperListURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Redpaper/index"]

//任务列表
#define  TaskListURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list"]
//任务详情
#define  TaskDetailURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_details"]
//立即接单 -- 羊头pc接单
#define  TaskReciveURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/my_task_list"]

//z账户密码 登陆
#define LoginURL           [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/login"]  
                             //@"http://apiyzt.youmeng.com/Api/Site/login"
//快捷登录
#define QuickLoginURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/quickLogin"]

//参与记录列表
#define AuditListURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/auditList/index"]

//项目详情
#define ProductDetailURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"PlatformDetails/index"]
//合作人明细
#define InviteFriendsURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"InviteFriends/home"]
//签到页面
#define UserSignListURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"usersign/sign_list"]

//我的任务列表 待处理
#define MyTaskListPending      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_pending"]

//我的任务列表  审核中
#define MyTaskListAudit        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_audit"]
//我的任务列表  审核成功
#define MyTaskListSuccess      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_success"]
//我的任务列表  已失效
#define MyTaskListFailed       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_failed"]
//我的任务 放弃任务
#define AuditMyTaskURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_audit_status"]

//我的钱包 信息
#define UserPayInfoURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/GetUserPayinfo"]

//绑定 修改 支付宝 银行卡
#define AddBankCardURL        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/FirstAddPayAccount"]
//绑定 修改 支付宝
//#define AddZFBAccountURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/payaccount/bindpayaccount"]

// 设置 修改支付密码
#define SetPassWordURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/FirstSetUserPayPass"]
//支付密码 验证手机号
#define  CheckPwdCaptchaURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/sms_interface/check_reset_pwd_captcha"]
//#define ResetPassWordCheckPhoneURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/sms_interface/send"]
//#define ModifyAccountURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/payaccount/ModifyAlipay"]

//支付宝 验证手机号
#define  CheckAliCaptchaURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/sms_interface/check_reset_alipay_captcha"]

//提现接口
#define GetWithdrawMoneyURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/getWithdrawMoney"]
//消息列表
#define MessageListURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/index"]
//消息详情
#define MessageDetailURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/message_details"]
//删除消息
#define MessageDeleteURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/delUserMessage"]
//阅读消息
#define MessageReadURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/message_read"]

#endif /* URLs_h */
