//
//  YMForgetViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMForgetViewController.h"
#import "YMResetPasswordController.h" //忘记重置密码
#import "YMModifyPasswdController.h"  //修改密码

@interface YMForgetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;

@end

@implementation YMForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalTime = 60;
    
    //监听字体处理按钮颜色
    _nextBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] > 0  ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    //设置layer
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    [YMTool viewLayerWithView:_nextBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    //修改密码
    if (self.passwordType == PasswordTypeModify) {
        if ([kUserDefaults valueForKey:kPhone]) {
            _phoneTextFd.text = [kUserDefaults valueForKey:kPhone];
            _phoneTextFd.userInteractionEnabled = NO;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听输入框的 字体 变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeHandle:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _nextBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] > 0 ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor : NavBar_UnabelColor;
}
- (IBAction)getCodeBtnClick:(id)sender {
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];           //[kUserDefaults valueForKey:kUid]
    [param setObject:@"updatePasswd" forKey:@"method"];
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        //显示提示信息
        [MBProgressHUD showFail:msg view:self.view];
        if (status.integerValue == 1) {
             _timer   = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
        }
    }];
}
-(void)getCodeMessage{
   // DDLog(@"获取验证码 倒计时");
    _totalTime --;
    if (_totalTime != 0 ) {
        _getCodeBtn.userInteractionEnabled = NO;
        [_getCodeBtn setBackgroundColor:LightGrayColor];
        [_getCodeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"   已发送%lds",(long)_totalTime];
    }
    else{
        _getCodeBtn.userInteractionEnabled = YES;
        _getCodeBtn.titleLabel.text = @"  获取验证码";
        _getCodeBtn.backgroundColor  = WhiteColor;
        [_getCodeBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        _totalTime = 60;
        //先停止，然后再某种情况下再次开启运行timer
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}
#pragma mark - 按钮点击事情
- (IBAction)nextBtnClick:(id)sender{
    DDLog(@"点击啦密码下一步");
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    if (_passwordTextFd.text.length < 4) {
        [MBProgressHUD showFail:@"手机验证码格式不正确，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:_passwordTextFd.text forKey:@"captcha"];//[kUserDefaults valueForKey:kToken]
    [param setObject:@"update-passwd" forKey:@"type"];       //修改密码
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:ValidateMsgURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.integerValue == 1) {
            YMResetPasswordController* rvc = [[YMResetPasswordController alloc]init];
            rvc.passwordType = self.passwordType;
            if (self.passwordType == PasswordTypeModify) {
                rvc.title = @"修改密码";
            }else{
                rvc.title = @"找回密码-重置密码";
            }
            [weakSelf.navigationController pushViewController:rvc animated:YES];
        }else{
             //显示提示信息
             [MBProgressHUD showFail:msg view:weakSelf.view];
        }
    }];
}


@end
