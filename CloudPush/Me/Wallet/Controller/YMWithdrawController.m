//
//  YMWithdrawController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawController.h"
#import "YMWithdrawStyleCell.h"
#import "YMButtonFootCell.h"
#import "YMWithdrawCell.h"
#import "YMWithdrawStyleController.h"
#import "YMUserManager.h"
#import "YMPaySecrectController.h"

#import "GRBkeyTextField.h"
#import "GRBsafeKeyBoard.h"
#import "UIColor+extention.h"
#import <Masonry/Masonry.h>

@interface YMWithdrawController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UIButton* sureBtn;

@property(nonatomic,strong)YMWithdrawCell* withdrawCell;

//安全键盘
@property(nonatomic,strong) GRBkeyTextField * safeInputTextField;
@property(nonatomic,strong) GRBsafeKeyBoard * board;
@end

@implementation YMWithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YMButtonFootCell* cell = [YMButtonFootCell shareCell];
    _sureBtn = cell.sureBtn ;
    YMWeakSelf;
    cell.actionBlock = ^(UIButton* btn){
        DDLog(@"按钮点击啦");
        [weakSelf inputPayPassword];
    };
    self.tableView.tableFooterView = cell;
    
    //显示警告框
    [self showAlertView];
    
    //按钮颜色
    _sureBtn.enabled = [_withdrawCell.withdrawCrashTextFd.text length] > 0 && [_withdrawCell.withdrawCrashTextFd.text floatValue] >= 50  && _withdrawCell.withdrawCrashTextFd.text.floatValue <= _usrModel.useMoeny.floatValue && self.withdrawStyle > 0;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听输入框的 字体 变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeHandle:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPayStyleChanged:) name:kNotification_UserDataChanged object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
}
//弹出键盘 -- 输入支付密码
-(void)inputPayPassword{
    self.board = [GRBsafeKeyBoard GRB_showSafeInputKeyBoard];
    YMWeakSelf;
    self.board.GRBsafeKeyFinish=^(NSString * passWord){
        if (passWord.length == 6) {
            [weakSelf.board GRB_endKeyBoard];
            //请求网络
            [weakSelf requestWithDrawCrashWithPassWord:passWord];
        }
    };
    self.board.GRBsafeKeyClose = ^{
        [weakSelf.board GRB_endKeyBoard];
    };
    self.board.GRBsafeKeyForgetPassWord = ^{
        DDLog(@"点击忘记密码了");
        YMPaySecrectController* pvc = [[YMPaySecrectController alloc]init];
        pvc.setType = SetTypePayWordModify;
        pvc.title   = @"重置支付密码";
        pvc.isWithdraw = YES;
        [weakSelf.navigationController pushViewController:pvc animated:YES];
    };
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜
     _sureBtn.enabled = [_withdrawCell.withdrawCrashTextFd.text length] > 0 && [_withdrawCell.withdrawCrashTextFd.text floatValue] >= 50  && _withdrawCell.withdrawCrashTextFd.text.floatValue <= _usrModel.useMoeny.floatValue && self.withdrawStyle > 0;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    if (_withdrawCell.withdrawCrashTextFd.text.floatValue > _usrModel.useMoeny.floatValue) {
        _withdrawCell.warnLabel.textColor = RedColor;
        _withdrawCell.warnLabel.text = @"输入金额已超过可提现金额";
        return;
    }
    if (_withdrawCell.withdrawCrashTextFd.text.floatValue < 50) {
        _withdrawCell.warnLabel.textColor = RedColor;
        _withdrawCell.warnLabel.text = @"最低提现金额为50元";
        return;
    }
        _withdrawCell.warnLabel.textColor = LightGrayColor;
        _withdrawCell.warnLabel.text = [NSString stringWithFormat:@"可提余额%@元",_usrModel.useMoeny];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_UserDataChanged object:nil];

}

-(void)showAlertView{
    if (self.usrModel.isSetPasswd.integerValue == 0) {
        UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲爱的用户，为了您的资金安全，您需要设置支付密码才能提现！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YMPaySecrectController* pvc = [[YMPaySecrectController alloc]init];
            pvc.setType = SetTypePayWordModify;
            pvc.title   = @"设置支付密码";
            pvc.isWithdraw = YES;
            [self.navigationController pushViewController:pvc animated:YES];
        }];
        [alerC addAction:cancelAction];
        [alerC addAction:sureAction];
        [self presentViewController:alerC animated:YES completion:nil];
        return;
    }

}
-(void)userPayStyleChanged:(NSNotification*)notif{
    DDLog(@"支付状态改变了 notif == %@ userInfo == %@",notif.object,notif.userInfo);
    SetType setType = [notif.object integerValue];
    if (setType == SetTypeZhiFuBaoUnSet) {
        self.withdrawStyle = WithDrawCrashStyleZfb;
        self.model = [[TitleModel alloc]init];
        self.model.title = @"支付宝";
        self.model.icon = @"alipay";
        self.model.withdrawStyle = WithDrawCrashStyleZfb;
        self.model.isZfb = @1;
    }else if(setType == SetTypeBankCardUnSet) {
        self.withdrawStyle = WithDrawCrashStyleBankCard;
        self.model = [[TitleModel alloc]init];
        self.model.title = @"银行卡";
        self.model.icon = @"Unionpay";
        self.model.withdrawStyle = WithDrawCrashStyleBankCard;
        self.model.isCard = @1;
    }else if(setType == SetTypePayWordModifyTwice){
        
    }
    [self requestUserData];
}
-(void)requestUserData{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];     //
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        weakSelf.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [[YMUserManager shareInstance] saveUserInfoByUsrModel:weakSelf.usrModel];
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - request  提现
-(void)requestWithDrawCrashWithPassWord:(NSString* )passWord{
    //显示警告框
    [self showAlertView];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    if (self.withdrawStyle == WithDrawCrashStyleZfb) {
        [param setObject:_usrModel.isZfb_realName forKey:@"realName"];
        [param setObject:_usrModel.isZfb_accountName forKey:@"accountName"];
        [param setObject:@"1" forKey:@"extract_type"];
    }else if (self.withdrawStyle == WithDrawCrashStyleBankCard){
        [param setObject:_usrModel.isCard_realName forKey:@"realName"];
        [param setObject:_usrModel.isCard_accountName forKey:@"accountName"];
        [param setObject:@"4" forKey:@"extract_type"];
    }
    DDLog(@"param == %@",param);
    if ([kUserDefaults valueForKey:kUid]) {
         [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
    }
    if ([kUserDefaults valueForKey:kToken]) {
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    }
    [param setObject:_withdrawCell.withdrawCrashTextFd.text forKey:@"money"];
   
    [param setObject:passWord forKey:@"passwd"];//支付密码
    
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:GetWithdrawMoneyURL params:param view:self.view isEdit:YES loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.integerValue == 1) {
            _sureBtn.userInteractionEnabled = NO;
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"提现申请已提交成功，等待%@处理",self.withdrawStyle == WithDrawCrashStyleBankCard ? @"银行":@"支付宝"] view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //提现方式
                [kUserDefaults setObject:responseObject[@"data"] forKey:kPayStyle];
                //通知数据改变
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UserDataChanged object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        if (status.integerValue == 5) {
            [MBProgressHUD showFail:[NSString stringWithFormat:@"支付密码错误，还剩%@次机会!",responseObject[@"data"]] view:self.view];
            //_sureBtn.enabled = NO;
        }
        else if(status.integerValue <= 0){
            [MBProgressHUD showFail:msg view:self.view];
        }
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YMWithdrawStyleCell * cell = [YMWithdrawStyleCell cellDequeueReusableCellWithTableView:tableView];
        cell.model = self.model;
        cell.selectImgView.hidden = NO;
        cell.selectImgView.image = [UIImage imageNamed:@"my_more"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        YMWithdrawCell* cell = [YMWithdrawCell shareCell];
        _withdrawCell = cell;
        _withdrawCell.withdrawCrashTextFd.delegate = self;
        _withdrawCell.warnLabel.text = [NSString stringWithFormat:@"可提余额%@元",_usrModel.useMoeny];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YMWeakSelf;
        [cell handleWithdrawBlock:^(UIButton *btn, UITextField *moneyTextFd, UILabel *warnLabel) {
             DDLog(@"money == %@",moneyTextFd.text);
             _withdrawCell.withdrawCrashTextFd.text = _usrModel.useMoeny;
             //执行一下 键盘监听 方法
             [weakSelf textDidChangeHandle:nil];
        }];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 116;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YMWithdrawStyleController* ymc = [[YMWithdrawStyleController alloc]init];
        ymc.usrModel = self.usrModel;
        ymc.title = @"选择支付方式";
        //支付方式
        ymc.withdrawStyle = self.withdrawStyle;
        YMWeakSelf;
        ymc.typeBlock = ^(WithDrawCrashStyle type,TitleModel* model){
            weakSelf.withdrawStyle = type;
            weakSelf.model         = model;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ymc animated:YES];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
