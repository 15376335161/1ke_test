//
//  YMRegistViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMRegistViewController.h"
#import "YMLoginController.h"
#import "HyperlinksButton.h"
#import "YMTool.h"
#import "YMWebViewController.h"
#import "YMUserManager.h"
#import "UserModel.h"
#import "UIView+YSTextInputKeyboard.h"
#import "RSAEncryptor.h"


@interface YMRegistViewController ()<UIGestureRecognizerDelegate>

//电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextFd;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
//邀请码
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextFd;
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

//注册诱梦协议
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

//登陆按钮
@property (weak, nonatomic) IBOutlet HyperlinksButton *loginBtn;
//立即注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,copy)NSString* isAgree;

@end

@implementation YMRegistViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册有盟账号";
    //初始化view
    [self modifyView];
    
    //监听字体处理按钮颜色
    _registBtn.enabled = [_phoneTextFd.text length] > 0 && [_codeTextFd.text length] > 0 && [_passwordTextFd.text length] > 0 ;
    _registBtn.backgroundColor = _registBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    _totalTime = 60;
    
//    //通过offset的设置可以设置某个输入框特殊偏移量。
//    self.inviteCodeTextFd.kbMoving.offset = 50;
//    
//    //你也可以通过设置一个具体的移动的视图而不是默认的父视图
//    self.inviteCodeTextFd.kbMoving.kbMovingView = self.view;    
//    self.inviteCodeTextFd.kbMoving.offset = 0;

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
   // [self.view endEditing:YES];
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
-(void)modifyView{
    //设置layer
    //设置圆角
    _getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    [YMTool viewLayerWithView:_registBtn cornerRadius:4 boredColor:nil borderWidth:1];
    //注册协议
    [YMTool labelColorWithLabel:_protocolLabel font:Font(12) range:NSMakeRange(_protocolLabel.text.length - 6, 6) color:RedColor];
    //登陆按钮
    [self.loginBtn setColor:NavBarTintColor];
    //添加协议
     _protocolLabel.userInteractionEnabled = YES;
    [YMTool addTapGestureOnView:_protocolLabel target:self selector:@selector(protocolLabelClick:) viewController:self];
    
}
#pragma mark - 按钮响应方法
//获取验证码
- (IBAction)getCodeBtnClick:(id)sender {
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
    [param setObject:@"register" forKey:@"method"];
 
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSString* msg    = responseObject[@"msg"];
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
- (IBAction)loginBtnClick:(id)sender {
    DDLog(@"点击啦登录按钮");
    if (self.tag == 1) {
        //self.tagBlock(1);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        YMLoginController* lvc = [[YMLoginController alloc]init];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}
//注册用户
- (IBAction)regestBtnClick:(id)sender {
    DDLog(@"注册用户");
//    if (self.isAgree == nil) {
//        [MBProgressHUD showFail:@"请同意诱梦用户协议！" view:self.view];
//        return;
//    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:_codeTextFd.text forKey:@"captcha"];
    [param setObject:[RSAEncryptor encryptString:_passwordTextFd.text publicKey:kPublicKey] forKey:@"passwd"];
   // [param setObject:@"1" forKey:@"isAgreement"];
    if (_inviteCodeTextFd.text) {
         [param setObject:_inviteCodeTextFd.text forKey:@"sharecode"];
    }
    
    [[HttpManger sharedInstance]callHTTPReqAPI:RegisterURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
           NSNumber* status = responseObject[@"status"];
           NSString* msg    = responseObject[@"msg"];
           if (status.integerValue == 1) {
               //保存数据
                UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
                [[YMUserManager shareInstance]saveUserInfoByUsrModel:usrModel];
                for (UIViewController* vc in self.navigationController.viewControllers) {
                   DDLog(@"nav class == %@",[vc class]);
                }
               //回退2级
               if (self.navigationController.viewControllers.count > 2) {
                   [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
               }
           }else{
               [MBProgressHUD showFail:msg view:self.view];
           }
    }];
}

//注册协议
-(void)protocolLabelClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦协议");
    YMWebViewController* wvc = [[YMWebViewController alloc]init];
    wvc.title   =  @"注册协议";
    wvc.agreeBlock = ^(NSString* isAgree){
        self.isAgree = isAgree;
    };
    wvc.urlStr  =  @"http://passport.youmeng.com/reg/agrement";
    [self.navigationController pushViewController:wvc animated:YES];
}
#pragma mark - UITextFieldDelegate
-(void)textDidChangeHandle:(NSNotification* )notification{
    //监听字体处理按钮颜色
    _registBtn.enabled = [_phoneTextFd.text length] > 0 && [_codeTextFd.text length] > 0 && [_passwordTextFd.text length] > 0 ;
    _registBtn.backgroundColor = _registBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
}

#pragma mark - 键盘处理
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
