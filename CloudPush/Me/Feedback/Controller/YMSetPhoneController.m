//
//  YMSetPhoneController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSetPhoneController.h"
#import "YMSetPhoneTwiceController.h"

@interface YMSetPhoneController ()
//验证码btn
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFd;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
//联系电话
@property (weak, nonatomic) IBOutlet UILabel *serviceTelLabel;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;
@end

@implementation YMSetPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalTime = 60;
    _phoneTextFd.text = [kUserDefaults valueForKey:kPhone];
    _phoneTextFd.userInteractionEnabled = NO;
    //监听字体处理按钮颜色
    _nextBtn.enabled = [_codeTextFd.text length] >= 6 ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    //设置layer
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    [YMTool viewLayerWithView:_nextBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
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
    _nextBtn.enabled = [_codeTextFd.text length]  >= 6 ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor : NavBar_UnabelColor;
}
-(void)dealloc{
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (IBAction)nextBtnClick:(id)sender {
    DDLog(@"下一步按钮点了");
    if (_codeTextFd.text.length != 6) {
        [MBProgressHUD showFail:@"验证码格式不正确！请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kPhone] forKey:@"phone"];
    [param setObject:_codeTextFd.text forKey:@"captcha"];
    [param setObject:@"update-phone-old" forKey:@"type"];//修改手机 旧手机验证
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:ValidateMsgURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.integerValue == 1) {
            YMSetPhoneTwiceController* svc = [[YMSetPhoneTwiceController alloc]init];
            svc.title = @"密保手机";
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            //显示提示信息
            [MBProgressHUD showFail:msg view:weakSelf.view];
        }
    }];
}
- (IBAction)getCodeClick:(id)sender {
    DDLog(@"获取验证码");
    NSString* urlStr ;
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:[kUserDefaults valueForKey:kPhone] forKey:@"phone"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"]; 
    [param setObject:@"updatePhoneOld" forKey:@"method"];//修改手机发送给旧手机
    
    urlStr = SendMsgCodeURL;
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
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



@end
