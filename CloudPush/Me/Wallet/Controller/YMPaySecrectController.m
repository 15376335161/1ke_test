//
//  YMPaySecrectController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/6.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMPaySecrectController.h"
#import "YMWalletController.h"
#import "NSString+Catogory.h"

@interface YMPaySecrectController ()
//警告label
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
//标签
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
//输入框
@property (weak, nonatomic) IBOutlet UITextField *firstTextFd;
@property (weak, nonatomic) IBOutlet UITextField *secondTextFd;

//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;
@end

@implementation YMPaySecrectController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //修改view
    [self modifyView];
    
     _totalTime = 60;
    //监听字体处理按钮颜色
    [YMTool viewLayerWithView:_sureBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    _sureBtn.enabled = [_secondTextFd.text length] > 0 && [_firstTextFd.text length] > 0  ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor : NavBar_UnabelColor;
    
    //设置layer
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    
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
#pragma mark - UI
-(void)modifyView {
    //设置支付密码  或者  修改密码
    self.getCodeBtn.hidden = YES;
    if (self.setType == SetTypePayWordUnSet ||
        self.setType == SetTypePayWordModifyTwice) {
        DDLog(@"设置密码");
        _firstNameLabel.text  = @"支付密码";
        _secondNameLabel.text = @"确认支付密码";
        _firstTextFd.placeholder = @"请输入支付密码";
        _secondTextFd.placeholder = @"请输入确认支付密码";
        
        if (self.setType == SetTypePayWordModifyTwice) {
            _firstTextFd.text = [kUserDefaults valueForKey:kPasswd];
            
            //_secondTextFd.placeholder = @"请输入确认支付密码";
        }
    }
    //设置支付宝账户
    else if (self.setType == SetTypeZhiFuBaoUnSet){
        DDLog(@"设置支付宝");
        self.getCodeBtn.hidden = NO;
        _firstNameLabel.text = @"支付宝账号";
        _firstTextFd.placeholder = @"请输入支付宝账号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
    }else if ( self.setType == SetTypeZhiFuBaoModify || //修改支付宝密码第一步
               self.setType == SetTypePayWordModify   ||//修改支付密码第一步
               self.setType == SetTypeBankCardModify ){ //修改银行卡第一步  验证手机号
        DDLog(@"修改支付宝");
        self.getCodeBtn.hidden = NO;
        _warnLabel.text = @"为了您的账户安全，请完成手机验证";
        _firstNameLabel.text = @"手机号";
        _firstTextFd.placeholder = @"请输入手机号码";
        _secondNameLabel.text     = @"验证码";
        _secondTextFd.placeholder = @"请输入验证码";
        //键盘类型
        _firstTextFd.keyboardType  = UIKeyboardTypeNumberPad;
        _secondTextFd.keyboardType = UIKeyboardTypeNumberPad;
        [_sureBtn setTitle:@"下一步" forState:UIControlStateNormal];
        //手机号
        _firstTextFd.text         = [kUserDefaults valueForKey:kPhone];
    }
    //设置银行卡
    else if (self.setType == SetTypeBankCardUnSet){
        DDLog(@"设置银行卡");
        _firstNameLabel.text = @"银行卡号";
        _firstTextFd.placeholder = @"请输入银行卡号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
    }
    //修改支付宝 第二步
    else if (self.setType == SetTypeZhiFuBaoModifyTwice){
        DDLog(@"修改支付宝");
        self.getCodeBtn.hidden = YES;
        _firstNameLabel.text = @"支付宝账号";
        _firstTextFd.placeholder = @"请输入支付宝账号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
        //支付宝账户
        //NSString* accountName = [kUserDefaults valueForKey:kZfb_accountName];
        _firstTextFd.text  = [kUserDefaults valueForKey:kZfb_accountName];
        //[NSString string:accountName replaceStrInRange:NSMakeRange(4, accountName.length - 4) withString:@"****"];
        _secondTextFd.text = [kUserDefaults valueForKey:kZfb_realName];
        
        _secondTextFd.text = @"更改支付宝";
    }
    //修改银行卡 第二步
    else if (self.setType == SetTypeBankCardModifyTwice){
        DDLog(@"修改");
        _firstNameLabel.text = @"银行卡号";
        _firstTextFd.placeholder = @"请输入银行卡号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
        //修改银行卡
        _firstTextFd.text = [kUserDefaults valueForKey:kCard_accountName];
        _secondTextFd.text = [kUserDefaults valueForKey:kCard_realName];
        
        _secondTextFd.text = @"更改银行卡";
    }
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _sureBtn.enabled = [_secondTextFd.text length] > 0 && [_firstTextFd.text length] > 0  ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
}

#pragma mark - 按钮点击事件
- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"点击啦确定按钮");
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    //设置银行卡
    if (self.setType == SetTypeBankCardUnSet) {
        [param setObject:@"1422" forKey:kUid];//
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"4" forKey:@"pay_type"];//
        //账户名
        [param setObject:_firstTextFd.text forKey:@"accountName"];
        //真实的用户名
        [param setObject:_secondTextFd.text forKey:@"realName"];
        [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
    
       //修改银行卡
    }
    //设置支付宝
    else if (self.setType == SetTypeZhiFuBaoUnSet){
        [param setObject:@"1422" forKey:kUid];    //
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"1" forKey:@"pay_type"];//
        //账户名
        [param setObject:_firstTextFd.text forKey:@"accountName"];
        //真实的用户名
        [param setObject:_secondTextFd.text forKey:@"realName"];
        
        [self setBankCardRequestWithParam:param urlStr:AddZFBAccountURL];
    }
    //修改支付宝。 银联卡。第一步。验证手机号
    else if (self.setType == SetTypeZhiFuBaoModify ||
             self.setType == SetTypeBankCardModify ||
             self.setType == SetTypePayWordModify){
        [param setObject:@"1422" forKey:kUid];//
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        //手机号
        [param setObject:_firstTextFd.text forKey:@"phone"];
        //验证码
        [param setObject:_secondTextFd.text forKey:@"phoneCode"];
        //验证支付密码
        if (self.setType == SetTypePayWordModify) {
             [self setBankCardRequestWithParam:param urlStr:CheckPwdCaptchaURL];
        }else{
           // 验证 支付宝
           [self setBankCardRequestWithParam:param urlStr:CheckAliCaptchaURL];
        }
    }
    //修改支付宝。第二步
    else if (self.setType == SetTypeZhiFuBaoModifyTwice){
        [param setObject:@"1422" forKey:kUid];//
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"1" forKey:@"pay_type"];//
        
        //账户名 @ . 后台需要解码
        [param setObject:_firstTextFd.text forKey:@"accountName"];//
        //真实的用户名
        [param setObject:[_secondTextFd.text stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8]  forKey:@"realName"];
        //[_secondTextFd.text stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8]
        //[_secondTextFd.text stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8]
        //[NSString stringEncodingWithStr:_secondTextFd.text CFStringEncoding:kCFStringEncodingUTF8]
        //[NSString base64StringFromText:_secondTextFd.text]
        
        [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
    }
    //修改银行卡第 二步
    else if (self.setType == SetTypeBankCardModifyTwice){
        [param setObject:@"1422" forKey:kUid];//
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"4" forKey:@"pay_type"];//
        //账户名
        [param setObject: _firstTextFd.text forKey:@"accountName"];
        //真实的用户名
        [param setObject:_secondTextFd.text forKey:@"realName"];//[NSString base64StringFromText:_secondTextFd.text]
        
        [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
    }
    //设置支付密码
    else if (self.setType == SetTypePayWordUnSet){
        [param setObject:_firstTextFd.text forKey:@"passwd"];
        [param setObject:_secondTextFd.text forKey:@"passwd_code"];
        
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"1422" forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
        
        [self setBankCardRequestWithParam:param urlStr:SetPassWordURL];
    }
    //修改支付密码
    else if (self.setType == SetTypePayWordModifyTwice) {
        [param setObject:_firstTextFd.text forKey:@"passwd"];
        [param setObject:_secondTextFd.text forKey:@"passwd_code"];
        
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"1422" forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
        
        [self setBankCardRequestWithParam:param urlStr:SetPassWordURL];
    }
}
//设置 或 修改 支付宝 银行卡账户
-(void)setBankCardRequestWithParam:(NSDictionary* )param urlStr:(NSString* )urlStr{
    YMWeakSelf;
    //银行卡绑定
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        DDLog(@"msg == %@",responseObject[@"msg"]);
        
        if (weakSelf.setType == SetTypeZhiFuBaoModifyTwice ||
            weakSelf.setType == SetTypeBankCardModifyTwice ||
            weakSelf.setType == SetTypePayWordModifyTwice) {
            for (UIViewController* vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[YMWalletController class]]) {
                    //数据改变
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UserDataChanged object:nil];
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
//             DDLog(@"self child == %@   %@",self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2],self.navigationController.childViewControllers);
//            YMWalletController* vc = weakSelf.navigationController.childViewControllers[weakSelf.navigationController.childViewControllers.count - 2];
//            //数据改变
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UserDataChanged object:@"dataChanged"];
//            [weakSelf.navigationController popToViewController:vc animated:YES];
        }
        //修改支付宝。手机号验证
        else if (weakSelf.setType == SetTypeZhiFuBaoModify ||
                 weakSelf.setType == SetTypeBankCardModify ||
                 weakSelf.setType == SetTypePayWordModify){
            YMPaySecrectController* pvc = [[YMPaySecrectController alloc]init];
            if (weakSelf.setType == SetTypeBankCardModify) {
                 pvc.title   = @"更改银行卡";
                 pvc.setType = SetTypeBankCardModifyTwice;
            }else if (weakSelf.setType == SetTypeZhiFuBaoModify){
                 pvc.title   = @"更改支付宝";
                 pvc.setType = SetTypeZhiFuBaoModifyTwice;
            }else{
                pvc.title   = @"更改支付密码";
                pvc.setType = SetTypePayWordModifyTwice;
            }
            [weakSelf.navigationController pushViewController:pvc animated:YES];
        }
        else{
            //数据改变
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UserDataChanged object:nil];
            if (weakSelf.refreshDataBlock) {
                weakSelf.refreshDataBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//修改支付宝账号  获取验证码
- (IBAction)getBtnClick:(id)sender {
    if (_firstTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_firstTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_firstTextFd.text forKey:@"phone"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];

    //修改支付密码  短信验证
    if (self.setType == SetTypePayWordModify) {
        [param setObject:@"ModifyPwdSmsCaptcha" forKey:@"method"];
    }
    //修改支付宝 银行卡 共一个短信验证
    else{
        [param setObject:@"ModifyAlipay" forKey:@"method"];
    }
    [param setObject:@"1422" forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
    // BaseApi
    //http://apiyzt.youmeng.com/
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        //显示提示信息
        [MBProgressHUD showFail:msg view:weakSelf.view];
        if (status.integerValue == 1) {
            _timer   = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
        }
        //状态 5 验证次数过多
        else if(status.integerValue == 5){
            weakSelf.sureBtn.enabled = NO;
        }
    }];
    
//    [[HttpManger sharedInstance]callWebHTTPReqAPI:@"http://apiyzt.youmeng.com/Api/sms_interface/send" params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
//        DDLog(@"res == %@",responseObject);
//        NSString* status = responseObject[@"status"];
//        NSString* msg    = responseObject[@"msg"];
//        //显示提示信息
//        [MBProgressHUD showFail:msg view:self.view];
//        if ([SUCCESS isEqualToString:status]) {
//            _timer   = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
//        }
//    }];
    
}
-(void)getCodeMessage{
   // DDLog(@"获取验证码 倒计时");
    _totalTime --;
    if (_totalTime != 0 ) {
        _getCodeBtn.userInteractionEnabled = NO;
        [_getCodeBtn setBackgroundColor:LightGrayColor];
        [_getCodeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@" 已发送%lds",(long)_totalTime];
    }
    else{
        _getCodeBtn.userInteractionEnabled = YES;
        _getCodeBtn.titleLabel.text = @" 获取验证码";
        _getCodeBtn.backgroundColor  = WhiteColor;
        [_getCodeBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        _totalTime = 60;
        //先停止，然后再某种情况下再次开启运行timer
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}



@end
