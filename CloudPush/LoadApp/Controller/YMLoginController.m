//
//  YMLoginController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLoginController.h"
#import "YMRegistViewController.h"
#import "YMForgetViewController.h"
#import "HyperlinksButton.h"
#import "UserModel.h"
#import "YMUserManager.h"

@interface YMLoginController ()
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//注册按钮
@property (weak, nonatomic) IBOutlet HyperlinksButton *registBtn;


@end

@implementation YMLoginController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录有盟账号";
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.clipsToBounds = YES;
    //注册按钮--设置下划线
    [_registBtn setColor:NavBarTintColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    DDLog(@"点击啦登录");
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
    [param setObject:_passwordTextFd.text forKey:@"passwd"];
    [param setObject:@"http://youmeng.com" forKey:@"forward"];
    
    [[HttpManger sharedInstance]callWebHTTPReqAPI:LoginURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        NSString* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        
        if ([status isEqualToString:@"LOGIN00001"]) {
            //保存用户信息
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"][@"I"]];
            [[YMUserManager shareInstance]saveUserInfoByUsrModel:usrModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:msg view:self.view];
        }
        
    }];
    
}
- (IBAction)forgetBtnClick:(id)sender {
    DDLog(@"忘记密码点击啦");
    YMForgetViewController* fvc = [[YMForgetViewController alloc]init];
    fvc.title = @"找回密码";
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

@end
