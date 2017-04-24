//
//  YMLoginController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLoginController.h"
#import "YMRegistViewController.h"
#import "YMForgetFirstController.h"
#import "HyperlinksButton.h"
#import "UserModel.h"
#import "YMUserManager.h"
#import "RSAEncryptor.h"
#import "YMTabBarController.h"
#import "YMSetLoginPswdController.h"

@interface YMLoginController ()<UITextFieldDelegate>
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//注册按钮
@property (weak, nonatomic) IBOutlet HyperlinksButton *registBtn;
//账户 手机登录
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *styleBtnArr;
//显示颜色区分
@property (weak, nonatomic) IBOutlet UILabel *lineView;

//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

//最大长度
@property(nonatomic,assign)NSInteger maxCount;

//标题label
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;

@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,assign)NSInteger totalTime;
//选择登录样式
@property(nonatomic,strong)UIButton* selectStyleBtn;
@end

@implementation YMLoginController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    _maxCount = 11; //最多11位
    _totalTime = 60;
    //注册按钮--设置下划线
    [_registBtn setColor:NavBarTintColor];
    //登陆按钮
    [YMTool viewLayerWithView:_loginBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    if (self.isHiddenBackBtn == NO) {
        //设置返回按钮
        [self setLeftBackButton];
    }
    //设置圆角
    _getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    for (UIButton* btn in _styleBtnArr) {
        [btn addTarget:self action:@selector(loginStyleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _getCodeBtn.hidden = YES;
        //默认选择第一个btn
        if (btn.tag == 100) {
            _selectStyleBtn = btn;
        }
    }
    //监听字体处理按钮颜色
    _loginBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] >= 6  ;
    _loginBtn.backgroundColor = _loginBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)loginStyleButtonClick:(UIButton* )btn{
    DDLog(@"btn tag == %d",btn.tag);
    //选中的按钮
    _selectStyleBtn = btn;
    if (btn.tag == 100) {
        //账户密码登录
        _getCodeBtn.hidden = YES;
        _secondTitleLabel.text       = @"密码";
        _passwordTextFd.placeholder  = @"6-14位字母数字组合";
        _passwordTextFd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordTextFd.text = nil;
    }else{
        //快捷登录
        _getCodeBtn.hidden = NO;
        _secondTitleLabel.text = @"验证码";
        _passwordTextFd.placeholder = @"请输入验证码";
        //键盘类型
        _passwordTextFd.keyboardType = UIKeyboardTypeNumberPad;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.sd_layout.xIs(btn.x);
    }];
}
//设置返回按钮
-(void)setLeftBackButton{
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = BackGroundColor;
}
-(void)back{
    if (self.isToTabBar == YES) {
        //跳转到第一个tabBar
        //修改密码 -- 重新回到主页面
        if (self.tag == 2) {
            //修改密码 -- 重新回到主页面
            YMTabBarController* tab = [[YMTabBarController alloc]init];
            [self presentViewController:tab animated:YES completion:nil];
        }else{
            YMTabBarController* tab = [[YMTabBarController alloc]init];
            [self presentViewController:tab animated:YES completion:nil];
        }
    }else{
         [self dismissViewControllerAnimated:YES completion:nil];
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
}
//获取验证码 点击啦
- (IBAction)getCodeBtnClick:(id)sender {
    DDLog(@"获取验证码");
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:@"quickLogin" forKey:@"method"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSString* msg    = responseObject[@"msg"];
        [_passwordTextFd becomeFirstResponder];
        //显示提示信息
        [MBProgressHUD showFail:msg view:self.view];
        NSNumber* status = responseObject[@"status"];
        //成功才会倒计时
        if (status.integerValue == 1) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
        }
    }];
}
-(void)getCodeMessage{
    //  DDLog(@"获取验证码 倒计时");
    _totalTime --;
    if (_totalTime != 0 ) {
        _getCodeBtn.userInteractionEnabled = NO;
        [_getCodeBtn setBackgroundColor:LightGrayColor];
        [_getCodeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@" 已发送%lds",(long)_totalTime];
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

-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _loginBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] >= 6 ;
    _loginBtn.backgroundColor = _loginBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    NSString *toBeString = _phoneTextFd.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_phoneTextFd markedTextRange];       //获取高亮部分的range
        //获取高亮部分的从range.start位置开始，向右偏移0所得的字符所在的位置。如果高亮部分不存在，那么就返回nil，反之就不是nil
        UITextPosition *position = [_phoneTextFd positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxCount) {
                _phoneTextFd.text = [toBeString substringToIndex:self.maxCount];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
           // _phoneTextFd.text
        }
    }
    // 中文输入法以外的直接对其统计限制即可
    else{
        if (toBeString.length > self.maxCount) {
            _phoneTextFd.text = [toBeString substringToIndex:self.maxCount];
        }
    }
}
#pragma mark - 按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码不正确！请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    NSString* urlStr ;
    if (_selectStyleBtn.tag == 100) {//账户 密码登录
        if (_passwordTextFd.text.length < 6 || _passwordTextFd.text.length > 14) {
            [MBProgressHUD showFail:@"密码格式为6-14位数字或字母，请重新输入！" view:self.view];
            return;
        }
        urlStr = LoginURL;
        [param setObject:_phoneTextFd.text forKey:@"username"];
        //加密
        [param setObject: [RSAEncryptor encryptString:_passwordTextFd.text publicKey:kPublicKey] forKey:@"passwd"];
    }else {
        if (_passwordTextFd.text.length != 6 ) {
            [MBProgressHUD showFail:@"验证码为6位数字，请重新输入！" view:self.view];
            return;
        }
        //手机快捷登录
        urlStr = QuickLoginURL;
        [param setObject:_phoneTextFd.text forKey:@"phone"];
        //加密
        [param setObject:_passwordTextFd.text  forKey:@"captcha"];
        [param setObject:@"iOS" forKey:@"source"];
    }
    //编辑
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view isEdit:YES  loading:YES  tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        //快捷登录 普通登录成功
        if (status.longValue == 1) {
            DDLog(@"tag == %ld isBar == %d",(long)self.tag,self.isToTabBar);
            //保存用户信息
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [[YMUserManager shareInstance] saveUserInfoByUsrModel:usrModel];
            //这个是为了修改密码  返回到首页
            if (self.isToTabBar == YES && self.tag == 2) {
                //可以返回
                //修改密码 -- 重新回到主页面
                YMTabBarController* tab = [[YMTabBarController alloc]init];
                [self presentViewController:tab animated:YES completion:nil];
                return ;
            }
            if (self.tag == 2) {
                //修改密码 -- 重新回到主页面
                YMTabBarController* tab = [[YMTabBarController alloc]init];
                [self presentViewController:tab animated:YES completion:nil];
            }else{
                //回退刷新数据
                [kUserDefaults setBool:YES forKey:kisRefresh];
                [kUserDefaults synchronize];
                //刷新页面
                if (self.refreshWebBlock) {
                    self.refreshWebBlock();
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //用户信息
            // [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LoginStatusChanged object:@""];
        }//注册成功
        else if (status.longValue == 2){
            //保存用户信息
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [[YMUserManager shareInstance] saveUserInfoByUsrModel:usrModel];
            YMSetLoginPswdController* svc = [[YMSetLoginPswdController alloc]init];
            svc.title = @"设置登录密码";
            [kUserDefaults setBool:YES forKey:kisRefresh];
            [kUserDefaults synchronize];
            svc.loginStatusBlock = ^(){
                _isToTabBar = YES;
            };
            [self.navigationController pushViewController:svc animated:YES];
        }
        else{
            [MBProgressHUD showSuccess:msg view:self.view];
        }
    }];
}
- (IBAction)forgetBtnClick:(id)sender {
    DDLog(@"忘记密码点击啦");
    YMForgetFirstController* fvc = [[YMForgetFirstController alloc]init];
    fvc.title = @"找回密码-填写账号信息";
    [self.navigationController pushViewController:fvc animated:YES];
}
- (IBAction)registBtnClick:(id)sender {
    DDLog(@"注册按钮点击啦");
    YMRegistViewController* rvc = [[YMRegistViewController alloc]init];
//    rvc.tagBlock = ^(NSInteger tag){
//        DDLog(@"tag == %ld",(long)tag);
//    };
    rvc.tag = 1;
    [self.navigationController pushViewController:rvc animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _phoneTextFd) {
        NSMutableString * mStr = [[NSMutableString alloc] initWithString:textField.text];
        [mStr insertString:string atIndex:range.location];
        return mStr.length <= 11;
    }
    else{
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _passwordTextFd) {
        [self loginBtnClick:_loginBtn];
        return YES;
    }
    return YES;
}

@end
