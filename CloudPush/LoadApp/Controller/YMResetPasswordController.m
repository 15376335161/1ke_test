//
//  YMResetPasswordController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/6.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMResetPasswordController.h"

@interface YMResetPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextFd;

//完成按钮
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation YMResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听字体处理按钮颜色
    _doneBtn.enabled = [_passwordTextFd.text length] > 0 && [_secondPasswordTextFd.text length] > 0  ;
    _doneBtn.backgroundColor = _doneBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    //设置颜色
    [YMTool viewLayerWithView:_doneBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _doneBtn.enabled = [_passwordTextFd.text length] > 0 && [_secondPasswordTextFd.text length] > 0  ;
    _doneBtn.backgroundColor = _doneBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
}

#pragma mark - 点击啦完成按钮
- (IBAction)doneBtnClick:(id)sender {
    DDLog(@"完成按钮点击啦");
    if (_passwordTextFd.text.length < 6 ) {
        [MBProgressHUD showFail:@"密码为6-16位的字母或数字，请重新输入！" view:self.view];
        return;
    }
    if (_secondPasswordTextFd.text.length < 6 ) {
        [MBProgressHUD showFail:@"密码为6-16位的字母或数字，请重新输入！" view:self.view];
        return;
    }
    if (![_passwordTextFd.text isEqualToString:_secondPasswordTextFd.text]) {
        [MBProgressHUD showFail:@"两次输入的密码不一致，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults  valueForKey:kToken] forKey:@"checkPhoneCaptcha"];
    [param setObject:_secondPasswordTextFd.text forKey:@"passwd"];
    
    YMWeakSelf;
    [[HttpManger sharedInstance]callWebHTTPReqAPI:ForgetSetPasswdURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.longValue == 1) {
           // [kUserDefaults setObject:responseObject[@"data"][@"token"] forKey:kToken];
           // [kUserDefaults synchronize];
            
            BOOL flag = NO;
            for (UIViewController* vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[YMLoginController class]]) {
                    flag = YES;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            if (flag == NO) {
                YMLoginController* lvc = [[YMLoginController alloc]init];
                [self.navigationController pushViewController:lvc animated:YES];
            }
           
        }else{
            //显示提示信息
            [MBProgressHUD showFail:msg view:weakSelf.view];
        }
    }];
    
}


@end
