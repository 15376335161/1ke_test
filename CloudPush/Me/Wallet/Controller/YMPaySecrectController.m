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
#import "YMWithdrawController.h"

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

//最大长度
@property(nonatomic,assign)NSInteger maxCount;

//上边的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarinConst;
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
}
-(void)dealloc{
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
        //键盘类型
        _firstTextFd.keyboardType  = UIKeyboardTypeNumberPad;
        _secondTextFd.keyboardType = UIKeyboardTypeNumberPad;
        
        //监听最大长度
        _maxCount = 6;
    }
    //设置支付宝账户
    else if (self.setType == SetTypeZhiFuBaoUnSet){
        DDLog(@"设置支付宝");
        self.getCodeBtn.hidden = NO;
        //设置支付宝
#warning todo
        _warnLabel.hidden = YES;
        _topMarinConst.constant = 25;
        _firstNameLabel.text = @"支付宝账号";
        _firstTextFd.placeholder = @"请输入支付宝账号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
        //隐藏
        _getCodeBtn.hidden = YES;
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
        _firstTextFd.userInteractionEnabled = NO;
    }
    //设置银行卡
    else if (self.setType == SetTypeBankCardUnSet){
        DDLog(@"设置银行卡");
        //设置银行卡
#warning todo
        _warnLabel.hidden = YES;
         _topMarinConst.constant = 25;
        _firstNameLabel.text = @"银行卡号";
        _firstTextFd.placeholder = @"请输入银行卡号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
        //键盘类型
        _firstTextFd.keyboardType  = UIKeyboardTypeNumberPad;
    }
    //修改支付宝 第二步
    else if (self.setType == SetTypeZhiFuBaoModifyTwice){
        DDLog(@"修改支付宝");
        //提示信息
#warning todo
        if (SCREEN_WIDTH == 320) {
             _topMarinConst.constant = 25;
        }
        _warnLabel.hidden = YES;
        self.getCodeBtn.hidden = YES;
        _firstNameLabel.text = @"支付宝账号";
        _firstTextFd.placeholder = @"请输入支付宝账号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
        //支付宝账户
        _firstTextFd.text  = [kUserDefaults valueForKey:kZfb_accountName];
        _secondTextFd.text = [kUserDefaults valueForKey:kZfb_realName];
 
    }
    //修改银行卡 第二步
    else if (self.setType == SetTypeBankCardModifyTwice){
        DDLog(@"修改");
        //提示信息
#warning todo
        if (SCREEN_WIDTH == 320) {
            _topMarinConst.constant = 25;
        }
        _warnLabel.hidden = YES;
        _firstNameLabel.text = @"银行卡号";
        _firstTextFd.placeholder = @"请输入银行卡号";
        _secondNameLabel.text = @"真实姓名";
        _secondTextFd.placeholder = @"请输入真实姓名";
        //键盘类型
        _firstTextFd.keyboardType  = UIKeyboardTypeNumberPad;
        //修改银行卡
        _firstTextFd.text = [kUserDefaults valueForKey:kCard_accountName];
        _secondTextFd.text = [kUserDefaults valueForKey:kCard_realName];
    }
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _sureBtn.enabled = [_secondTextFd.text length] > 0 && [_firstTextFd.text length] > 0  ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    if (self.setType == SetTypePayWordUnSet ||
        self.setType == SetTypePayWordModifyTwice) {
        if (_firstTextFd.text.length >= self.maxCount) {
              _firstTextFd.text  = [_firstTextFd.text substringToIndex:self.maxCount];
        }
        if (_secondTextFd.text.length >= self.maxCount) {
            _secondTextFd.text = [_secondTextFd.text substringToIndex:self.maxCount];
        }
//        NSString *toBeString = _firstTextFd.text;
//        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//        if ([lang isEqualToString:@"zh-Hans"]) {
//            // 简体中文输入，包括简体拼音，健体五笔，简体手写
//            UITextRange *selectedRange = [_firstTextFd markedTextRange];       //获取高亮部分的range
//            //获取高亮部分的从range.start位置开始，向右偏移0所得的字符所在的位置。如果高亮部分不存在，那么就返回nil，反之就不是nil
//            UITextPosition *position = [_firstTextFd positionFromPosition:selectedRange.start offset:0];
//            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//            if (!position) {
//                if (toBeString.length > self.maxCount) {
//                    _firstTextFd.text = [toBeString substringToIndex:self.maxCount];
//                }
//            }
//            // 有高亮选择的字符串，则暂不对文字进行统计和限制
//            else{
//                // _phoneTextFd.text
//            }
//        }
//        // 中文输入法以外的直接对其统计限制即可
//        else{
//            if (toBeString.length > self.maxCount) {
//                _firstTextFd.text = [toBeString substringToIndex:self.maxCount];
//            }
//        }

    }
}

#pragma mark - 按钮点击事件
- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"点击啦确定按钮");
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    DDLog(@"_secondTextFd.text.length == %ld",_secondTextFd.text.length);
    //设置银行卡
    if (self.setType == SetTypeBankCardUnSet) {
        if (![NSString isBankCard:_firstTextFd.text]) {
            [MBProgressHUD showFail:@"银行卡号格式不正确，请重新输入！" view:self.view];
            return;
        }
        if (_secondTextFd.text.length < 2) {
            [MBProgressHUD showFail:@"姓名格式不正确，请重新输入！" view:self.view];
            return;
        }
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];//
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"4" forKey:@"pay_type"];//
        //账户名
        [param setObject:_firstTextFd.text forKey:@"accountName"];
        //真实的用户名
        [param setObject:_secondTextFd.text forKey:@"realName"];
        
        //设置IP 参数
        if ([NSString getIPAddress]) {
            [param setObject:[NSString getIPAddress] forKey:@"ip"];
        }
        DDLog(@"getIPAddress == %@",[NSString getIPAddress]);
        //设置浏览器
        [param setObject:@"iOS" forKey:@"browser"];
        [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
    }
    //设置支付宝
    else if (self.setType == SetTypeZhiFuBaoUnSet){
        if (_secondTextFd.text.length < 2) {
            [MBProgressHUD showFail:@"姓名格式不正确，请重新输入！" view:self.view];
            return;
        }
        if ([NSString isMobileNum:_firstTextFd.text] || [NSString isAvailableEmail:_firstTextFd.text]) {
            [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];    //
            [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
            [param setObject:@"1" forKey:@"pay_type"];//
            //账户名
            [param setObject:_firstTextFd.text forKey:@"accountName"];
            //真实的用户名
            [param setObject:_secondTextFd.text forKey:@"realName"];
            //设置IP 参数
            if ([NSString getIPAddress]) {
                [param setObject:[NSString getIPAddress] forKey:@"ip"];
            }
            DDLog(@"getIPAddress == %@",[NSString getIPAddress]);
            //设置浏览器
            [param setObject:@"iOS" forKey:@"browser"];
            
            [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
        }else{
            [MBProgressHUD showFail:@"支付宝账户不正确！请重新输入！" view:self.view];
            return;
        }
    }
    //修改支付宝。 银联卡。第一步。验证手机号
    else if (self.setType == SetTypeZhiFuBaoModify ||
             self.setType == SetTypeBankCardModify ||
             self.setType == SetTypePayWordModify){
        
        if (![NSString isMobileNum:_firstTextFd.text]) {
            [MBProgressHUD showFail:@"手机号格式不正确，请重新输入！" view:self.view];
            return;
        }
        if (_secondTextFd.text.length < 5) {
            [MBProgressHUD showFail:@"验证码格式不正确，请重新输入！" view:self.view];
            return;
        }
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];//
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
        
        if (_secondTextFd.text.length < 2) {
            [MBProgressHUD showFail:@"姓名格式不正确，请重新输入！" view:self.view];
            return;
        }
        if ([NSString isMobileNum:_firstTextFd.text] || [NSString isAvailableEmail:_firstTextFd.text]) {
        
            [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];//
            [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
            [param setObject:@"1" forKey:@"pay_type"];//
            //账户名 @ . 后台需要解码
            [param setObject:_firstTextFd.text forKey:@"accountName"];//
            //真实的用户名
            [param setObject:_secondTextFd.text  forKey:@"realName"];
            //设置IP 参数
            if ([NSString getIPAddress]) {
                 [param setObject:[NSString getIPAddress] forKey:@"ip"];
            }
            DDLog(@"getIPAddress == %@",[NSString getIPAddress]);
            //设置浏览器
            [param setObject:@"iOS" forKey:@"browser"];
            [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
        }else{
            [MBProgressHUD showFail:@"支付宝账户不正确！请重新输入！" view:self.view];
            return;
        }
    }
    //修改银行卡第 二步
    else if (self.setType == SetTypeBankCardModifyTwice){
        //16 19 位 银行卡 _firstTextFd.text.length < 16 || _firstTextFd.text.length > 20 ||
        if ( ![NSString isBankCard:_firstTextFd.text]) {
            [MBProgressHUD showFail:@"银行卡号格式不正确，请重新输入！" view:self.view];
            return;
        }
        if (_secondTextFd.text.length < 2) {
            [MBProgressHUD showFail:@"姓名格式不正确，请重新输入！" view:self.view];
            return;
        }
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];//
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:@"4" forKey:@"pay_type"];//
        //账户名
        [param setObject: _firstTextFd.text forKey:@"accountName"];
        //真实的用户名
        [param setObject:_secondTextFd.text forKey:@"realName"];
        //设置IP 参数
        if ([NSString getIPAddress]) {
            [param setObject:[NSString getIPAddress] forKey:@"ip"];
        }
        DDLog(@"getIPAddress == %@",[NSString getIPAddress]);
        //设置浏览器
        [param setObject:@"iOS" forKey:@"browser"];
        [self setBankCardRequestWithParam:param urlStr:AddBankCardURL];
    }
    //设置支付密码
    else if (self.setType == SetTypePayWordUnSet){
        if (_firstTextFd.text.length != 6 || _secondTextFd.text.length != 6) {
            [MBProgressHUD showFail:@"支付密码为6位数字，请重新输入！" view:self.view];
            return;
        }
        if (![_firstTextFd.text isEqualToString:_secondTextFd.text]) {
            [MBProgressHUD showFail:@"两次输入的密码不一致！请重新输入！" view:self.view];
            return;
        }
        [param setObject:_firstTextFd.text forKey:@"passwd"];
        [param setObject:_secondTextFd.text forKey:@"passwd_code"];
        
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
        
        [self setBankCardRequestWithParam:param urlStr:SetPassWordURL];
    }
    //修改支付密码
    else if (self.setType == SetTypePayWordModifyTwice) {
        if (_firstTextFd.text.length < 6 || _secondTextFd.text.length < 6) {
            [MBProgressHUD showFail:@"密码格式不正确，请重新输入！" view:self.view];
            return;
        }
        if (![_firstTextFd.text isEqualToString:_secondTextFd.text]) {
            [MBProgressHUD showFail:@"两次输入的密码不一致！请重新输入！" view:self.view];
            return;
        }
        [param setObject:_firstTextFd.text forKey:@"passwd"];
        [param setObject:_secondTextFd.text forKey:@"passwd_code"];
        
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
        
        [self setBankCardRequestWithParam:param urlStr:SetPassWordURL];
    }
}
//设置 或 修改 支付宝 银行卡账户
-(void)setBankCardRequestWithParam:(NSDictionary* )param urlStr:(NSString* )urlStr{
    YMWeakSelf;
    //银行卡绑定
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        DDLog(@"msg == %@",responseObject[@"msg"]);
        
        //修改支付密码 修改银行卡 修改支付宝 成功 返回2级
        if (weakSelf.setType == SetTypeZhiFuBaoModifyTwice ||
            weakSelf.setType == SetTypeBankCardModifyTwice ||
            weakSelf.setType == SetTypePayWordModifyTwice) {
            //提现过来 添加的银行卡 支付保需要回退 到提现界面 并刷新数据
            if (weakSelf.isWithdraw == YES) {
                for (UIViewController* viewController in self.navigationController.childViewControllers) {
                    if ([viewController isKindOfClass:[YMWithdrawController class]]) {
                        //数据改变
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UserDataChanged object:@(weakSelf.setType)];
                        [weakSelf.navigationController popToViewController:viewController animated:YES];
                    }
                }
            }
            else{
                for (UIViewController* vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[YMWalletController class]]) {
                        //数据改变
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UserDataChanged object:nil];
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
            }
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
                pvc.title   = @"支付密码";
                pvc.setType = SetTypePayWordModifyTwice;
                //忘记支付密码 -- 传递
                if (self.isWithdraw == YES) {
                    pvc.isWithdraw = self.isWithdraw;
                }
            }
            [weakSelf.navigationController pushViewController:pvc animated:YES];
        }
        else {
            //提现过来 添加的银行卡 支付保需要回退 到提现界面 并刷新数据
            if (weakSelf.isWithdraw == YES) {
                
                for (UIViewController* viewController in self.navigationController.childViewControllers) {
                    if ([viewController isKindOfClass:[YMWithdrawController class]]) {
                        //数据改变
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UserDataChanged object:@(weakSelf.setType)];
                        [weakSelf.navigationController popToViewController:viewController animated:YES];
                    }
                }
            }
            else{
                //数据改变
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UserDataChanged object:nil];
                if (weakSelf.refreshDataBlock) {
                    weakSelf.refreshDataBlock();
                }
               [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//获取验证码   修改支付宝/银行账号
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
    if (self.setType == SetTypeZhiFuBaoModify) {
         [param setObject:@"ModifyAlipay" forKey:@"method"];
    }
    if (self.setType == SetTypeBankCardModify) {
       [param setObject:@"ModifyUnion" forKey:@"method"];
    }
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
    // BaseApi
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        //显示提示信息
        [MBProgressHUD showFail:msg view:weakSelf.view];
        if (status.integerValue == 1) {
            _timer   = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
            //发送验证码 验证码 选中
            [_secondTextFd becomeFirstResponder];
        }
        //状态 5 验证次数过多
        else if(status.integerValue == 5){
            weakSelf.sureBtn.enabled = NO;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
