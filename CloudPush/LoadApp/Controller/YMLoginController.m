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

@interface YMLoginController ()<UITextFieldDelegate>
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//注册按钮
@property (weak, nonatomic) IBOutlet HyperlinksButton *registBtn;

//最大长度
@property(nonatomic,assign)NSInteger maxCount;
@end

@implementation YMLoginController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录有盟账号";
    _maxCount = 11; //最多11位
    //注册按钮--设置下划线
    [_registBtn setColor:NavBarTintColor];
    
    //监听字体处理按钮颜色
    _loginBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] > 0  ;
    _loginBtn.backgroundColor = _loginBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;

    //登陆按钮
    [YMTool viewLayerWithView:_loginBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
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
    _loginBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] > 0  ;
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
        if (_passwordTextFd.text.length < 6 || _passwordTextFd.text.length > 32) {
            [MBProgressHUD showFail:@"密码格式为6-32位数字或字母，请重新输入！" view:self.view];
            return;
        }
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"username"];
    //加密
    [param setObject: [RSAEncryptor encryptString:_passwordTextFd.text publicKey:kPublicKey] forKey:@"passwd"];

    [[HttpManger sharedInstance]callHTTPReqAPI:@"http://apiyzt.youmeng.com/Api/Site/login" params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.intValue == 1) {
            //保存用户信息
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [[YMUserManager shareInstance]saveUserInfoByUsrModel:usrModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
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
