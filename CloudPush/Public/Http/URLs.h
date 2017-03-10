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
#define TOKEN_TIMEOUT   @"API_FAILURE_TOKEN_TIMEOUT"
#define FAILURE_TOKEN   @"API_FAILURE_TOKEN"



#define  BaseApi    @"http://apiyzt.youmeng.com/"

//任务列表
#define  TaskListURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list"]
//任务详情
#define  TaskDetailURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_details"]
//立即接单 -- 羊头pc接单
#define  TaskReciveURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/my_task_list"]

//登陆
#define LoginURL         @"http://passport.youmeng.com/login/index"
//验证码
#define LogincaptchaURL   @"http://passport.youmeng.com/captcha/logincaptcha"
//注册
#define RegstURL          @"http://passport.youmeng.com/reg"
//注册验证码
#define RegstSendCodeURL     @"http://passport.youmeng.com/reg/sendphoneregcode"
//找回密码获取验证码
#define ForgetSendCodeURL    @"http://passport.youmeng.com/find/sendphonecaptcha"
//修改密码 短信验证
#define ForgetCheckPhoneURL   @"http://passport.youmeng.com/find/checkphonecaptcha"

//修改密码 设置密码
#define ForgetSetPasswdURL    @"http://passport.youmeng.com/find/resetpasswd"

//我的任务列表 待处理
#define MyTaskListPending      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_pending"]

//我的任务列表  审核中
#define MyTaskListAudit        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_audit"]
//我的任务列表  审核成功
#define MyTaskListSuccess        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_success"]
//我的任务列表  已失效
#define MyTaskListFailed        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_failed"]
//我的任务 放弃任务
#define AuditMyTaskURL        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_audit_status"]



#endif /* URLs_h */
