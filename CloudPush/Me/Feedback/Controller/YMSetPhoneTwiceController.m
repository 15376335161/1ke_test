//
//  YMSetPhoneTwiceController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSetPhoneTwiceController.h"
#import "YMSetController.h"

@interface YMSetPhoneTwiceController ()
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;
@end

@implementation YMSetPhoneTwiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _totalTime = 60;
    
    //监听字体处理按钮颜色
    _sureBtn.enabled = [_codeTextFd.text length] >= 6 && _phoneTextFd.text.length > 0 ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    //设置layer
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    [YMTool viewLayerWithView:_sureBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
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
}

-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _sureBtn.enabled = [_codeTextFd.text length] >= 6 && _phoneTextFd.text.length > 0 ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
}
-(void)dealloc{
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (IBAction)getCodeClick:(id)sender {
    DDLog(@"获取验证码");
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码格式不正确，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:@"updatePhoneNew" forKey:@"method"];//修改手机发送给新手机

    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        [_codeTextFd becomeFirstResponder];
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
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"  已发送%lds",(long)_totalTime];
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

#pragma mark - 设置密保手机 成功之后 重新登录
- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"设置点击啦");
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码格式不正确！请重新输入！" view:self.view];
        return;
    }
    if (_codeTextFd.text.length != 6) {
        [MBProgressHUD showFail:@"验证码格式不正确！请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"newphone"];
    [param setObject:_codeTextFd.text forKey:@"captcha"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:UpdatePhoneURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.integerValue == 1) {
            [[YMUserManager shareInstance]removeUserInfo];
            [kUserDefaults setBool:NO forKey:kisRefresh];
            [kUserDefaults synchronize];
            
            YMLoginController* lvc = [[YMLoginController alloc]init];
            lvc.isToTabBar = YES;
            YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            //显示提示信息
            [MBProgressHUD showFail:msg view:weakSelf.view];
        }
    }];
}

@end
