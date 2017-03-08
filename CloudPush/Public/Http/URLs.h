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
#define RegstSendCode     @"http://passport.youmeng.com/reg/sendphoneregcode"


#endif /* URLs_h */
