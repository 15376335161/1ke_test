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


@interface YMWithdrawController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UIButton* sureBtn;
//@property(nonatomic,strong)UITextField* moneyTextFd;

@property(nonatomic,strong)YMWithdrawCell* withdrawCell;

@end

@implementation YMWithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YMButtonFootCell* cell = [YMButtonFootCell shareCell];
    _sureBtn = cell.sureBtn ;
    YMWeakSelf;
    cell.actionBlock = ^(UIButton* btn){
        DDLog(@"按钮点击啦");
        [weakSelf requestWithDrawCrash];
    };
    self.tableView.tableFooterView = cell;
    
    //按钮颜色
    _sureBtn.enabled = [_withdrawCell.withdrawCrashTextFd.text length] > 0 && [_withdrawCell.withdrawCrashTextFd.text length] > 0;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
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
    //监听字体处理按钮颜
    _sureBtn.enabled = [_withdrawCell.withdrawCrashTextFd.text length] > 0 && [_withdrawCell.withdrawCrashTextFd.text length] > 0 && _withdrawCell.withdrawCrashTextFd.text.floatValue <= _usrModel.useMoeny.floatValue ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    if (_withdrawCell.withdrawCrashTextFd.text.floatValue > _usrModel.useMoeny.floatValue) {
        _withdrawCell.warnLabel.textColor = RedColor;
        _withdrawCell.warnLabel.text = @"输入金额已超过可提现金额";
        //_sureBtn.enabled = NO;
    }else{
        _withdrawCell.warnLabel.textColor = LightGrayColor;
        _withdrawCell.warnLabel.text = [NSString stringWithFormat:@"可提余额%@元",_usrModel.useMoeny];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - request  提现
-(void)requestWithDrawCrash{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    if (self.withdrawStyle == WithDrawCrashStyleZfb) {
        [param setObject:_usrModel.isZfb_realName forKey:@"realName"];
        [param setObject:_usrModel.isZfb_accountName forKey:@"accountName"];
    }else{
        [param setObject:_usrModel.isCard_realName forKey:@"realName"];
        [param setObject:_usrModel.isCard_accountName forKey:@"accountName"];
    }
    DDLog(@"param == %@",param);
    if ([kUserDefaults valueForKey:kUid]) {
         [param setObject:@"1422" forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
    }
    if ([kUserDefaults valueForKey:kToken]) {
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    }
    [param setObject:_withdrawCell.withdrawCrashTextFd.text forKey:@"money"];
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:GetWithdrawMoneyURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
         [weakSelf.navigationController popViewControllerAnimated:YES];
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
        cell.selectImgView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        YMWithdrawCell* cell = [YMWithdrawCell shareCell];
        _withdrawCell = cell;
        _withdrawCell.withdrawCrashTextFd.delegate = self;
        _withdrawCell.warnLabel.text = [NSString stringWithFormat:@"可提余额%@元",_usrModel.useMoeny];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell handleWithdrawBlock:^(UIButton *btn, UITextField *moneyTextFd, UILabel *warnLabel) {
             DDLog(@"money == %@",moneyTextFd.text);
             _withdrawCell.withdrawCrashTextFd.text = _usrModel.useMoeny;
             [self textDidChangeHandle:nil];
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
