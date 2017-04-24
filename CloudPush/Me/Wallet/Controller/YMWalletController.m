//
//  YMWalletController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWalletController.h"
#import "YMSetTitileCell.h"
#import "YMSpecTitleCell.h"
#import "YMPaySecrectController.h"
#import "YMWalletHeadCell.h"
#import "YMWithdrawStyleController.h"

#import "YMWithdrawController.h"
#import "YMTitleActionCell.h"
#import "NSString+Catogory.h"
#import "YMWithdrawDetailController.h"


@interface YMWalletController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *navBarHairlineImageView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)YMWalletHeadCell* headCell;
@end

@implementation YMWalletController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //修改 设置头部
    [self mofifyView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //再定义一个imageview来等同于这个黑线
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataChanged:)
                                                 name:kNotification_UserDataChanged
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //恢复之前的导航色
    navBarHairlineImageView.hidden = NO;
    
}

-(void)dealloc{
    //消息中心 数据改变
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_UserDataChanged object:nil];
}
//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
#pragma mark - ModifyView
-(void)mofifyView{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    YMWalletHeadCell* cell = [YMWalletHeadCell shareCell];
    cell.model = self.usrModel;
    cell.tapViewBlock = ^(UITapGestureRecognizer *tap) {
            YMWithdrawDetailController* mvc = [[YMWithdrawDetailController alloc]init];
            if (tap.view.tag == 101) {
                mvc.title = @"提现明细";
                mvc.detailListType = DetailListTypeWithdraw;
            }else if (tap.view.tag == 100) {//待发明细
                mvc.title = @"待发明细";
                mvc.detailListType = DetailListTypeWaitIssue;
            }
            else if (tap.view.tag == 103) {//余额
                mvc.title = @"余额明细";
                mvc.detailListType = DetailListTypeBalance;
            }else{
                //累积收入 --- 待处理 不跳转
                return ;
            }
            [self.navigationController pushViewController:mvc animated:YES];
    };
    self.tableView.tableHeaderView = cell;
    //tableViewHead
    self.headCell = cell;
    
}
#pragma mark - 监听数据变化
-(void)userDataChanged:(NSNotification* )notification{
    NSString* userInfo = [notification valueForKey:@"object"];
    DDLog(@"notDic === %@  notification == %@",userInfo,notification);
    [self requestUserData];
}
-(void)userLoginOut:(NSNotification* )notification{
    DDLog(@"用户推出登录");
    _usrModel = nil;
}
-(void)requestUserData{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];      //
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        weakSelf.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [[YMUserManager shareInstance] saveUserInfoByUsrModel:weakSelf.usrModel];
         weakSelf.headCell.model = weakSelf.usrModel;
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 2;
    }
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMTitleActionCell* cell = [YMTitleActionCell cellDequeueReusableCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YMWeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [cell cellWithTitle:@"提现" icon:@"withdraw deposit"];
                cell.actBtn.hidden = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }else{
                [cell cellWithTitle:@"支付密码" icon:@"password"];
                cell.actionBlock = ^(UIButton * btn){
                    DDLog(@"修改 设置支付密码");
                    [weakSelf pushToViewController:[YMPaySecrectController alloc] userModel:weakSelf.usrModel indexPath:indexPath];
                };
                if (self.usrModel.isSetPasswd.integerValue) {
                    [cell.actBtn setTitle:@"更改" forState:UIControlStateNormal];
                }else{
                    [cell.actBtn setTitle:@"设置" forState:UIControlStateNormal];
                }
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.actionBlock = ^(UIButton * btn){
                    DDLog(@"修改 设置支付密码");
                   [weakSelf pushToViewController:[YMPaySecrectController alloc] userModel:weakSelf.usrModel indexPath:indexPath];
                };
                if (self.usrModel.isZfb.integerValue == 1) {
                    //手机号
                    if ([NSString isMobileNum:self.usrModel.isZfb_accountName]) {
                        [cell cellWithTitle:[NSString stringWithFormat:@"支付宝(%@)",[NSString string:self.usrModel.isZfb_accountName replaceStrInRange:NSMakeRange(3, 4) withString:@"****"]] icon:@"alipay"];
                    //邮箱账户
                    }else{
                        [cell cellWithTitle:[NSString stringWithFormat:@"支付宝(%@)",[NSString string:self.usrModel.isZfb_accountName replaceStrInRange:NSMakeRange(3, 4) withString:@"****"]] icon:@"alipay"];
                    }
                    [cell.actBtn setTitle:@"更改" forState:UIControlStateNormal];
                }else{
                    [cell cellWithTitle:@"支付宝" icon:@"alipayUnset"];
                    [cell.actBtn setTitle:@"设置" forState:UIControlStateNormal];
                }
            }else{
                cell.actionBlock = ^(UIButton * btn){
                    DDLog(@"修改 设置银联");
                    [weakSelf pushToViewController:[YMPaySecrectController alloc] userModel:weakSelf.usrModel indexPath:indexPath];
                };
                if (self.usrModel.isCard.integerValue == 1) {
                    if (self.usrModel.isCard_accountName.length > 4) {
                        [cell cellWithTitle:[NSString stringWithFormat:@"银联(尾号%@)",[self.usrModel.isCard_accountName substringFromIndex:self.usrModel.isCard_accountName.length - 4]] icon:@"Unionpay"];
                    }else{
                        [cell cellWithTitle:[NSString stringWithFormat:@"银联(尾号%@)",self.usrModel.isCard_accountName] icon:@"Unionpay"];
                    }
                    [cell.actBtn setTitle:@"更改" forState:UIControlStateNormal];
                }else{
                     [cell cellWithTitle:@"银联" icon:@"disabled_without_bank-card"];
                     [cell.actBtn setTitle:@"设置" forState:UIControlStateNormal];
                }
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)pushToViewController:(UIViewController* )viewController userModel:(UserModel* )usrModel indexPath:(NSIndexPath* )indexPath{
    
    YMWeakSelf;
    if (indexPath.section == 0 && indexPath.row == 1) {
        YMPaySecrectController * vc  = (YMPaySecrectController *)viewController;
        if (usrModel.isSetPasswd.integerValue ) {
            vc.title   = @"更改支付密码";
            vc.setType = SetTypePayWordModify;
        }else{
            vc.title = @"支付密码绑定";
            vc.setType = SetTypePayWordModify;
        }
        vc.refreshDataBlock = ^(){
            [weakSelf requestUserData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            YMPaySecrectController * vc  = (YMPaySecrectController *)viewController;
            if (usrModel.isZfb.integerValue) {
                vc.title = @"更改支付宝";
                vc.setType = SetTypeZhiFuBaoModify;
            }else{
                vc.title = @"支付宝绑定";
                vc.setType = SetTypeZhiFuBaoUnSet;
            }
            vc.refreshDataBlock = ^(){
                [weakSelf requestUserData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            YMPaySecrectController * vc  = (YMPaySecrectController *)viewController;
            if (usrModel.isCard.integerValue) {
                 vc.title   = @"更改银行卡";
                 vc.setType = SetTypeBankCardModify;
            }else{
                vc.title   = @"银行卡绑定";
                vc.setType = SetTypeBankCardUnSet;
            }
            vc.refreshDataBlock = ^(){
                [weakSelf requestUserData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [self showAlertView];
//                if (self.usrModel.isZfb.integerValue == 0 && self.usrModel.isCard.integerValue == 0) {
//                    YMWithdrawStyleController* yvc = [[YMWithdrawStyleController alloc]init];
//                    yvc.usrModel = self.usrModel;
//                    yvc.title = @"选择支付方式";
//                    [self.navigationController pushViewController:yvc animated:YES];
//                }
                YMWithdrawController* mvc = [[YMWithdrawController alloc]init];
                mvc.title = @"提现";
                mvc.usrModel = self.usrModel;
                TitleModel* model = [[TitleModel alloc]init];
                if (self.usrModel.isZfb.integerValue == 1) {
                    model.icon  = @"alipay";
                    model.title = @"支付宝";
                    model.isZfb = @1;
                    mvc.withdrawStyle = WithDrawCrashStyleZfb;
                }
                if (self.usrModel.isCard.integerValue == 1) {
                    model.icon =   @"Unionpay";
                    model.title =  @"银行卡";
                    model.isCard = @1;
                    mvc.withdrawStyle = WithDrawCrashStyleBankCard;
                }
                if (self.usrModel.isCard.integerValue == 0 && self.usrModel.isZfb.integerValue == 0 ){
                    model.icon  =  @"withdrawal_add";
                    model.title =  @"添加提现方式";
                    model.isCard = @0;
                    model.isZfb  = @0;
                }
                mvc.model = model;
                [self.navigationController pushViewController:mvc animated:YES];
            }else{
               [self pushToViewController:[YMPaySecrectController alloc] userModel:self.usrModel indexPath:indexPath];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                [self pushToViewController:[YMPaySecrectController alloc] userModel:self.usrModel indexPath:indexPath];
            }else{
                [self pushToViewController:[YMPaySecrectController alloc] userModel:self.usrModel indexPath:indexPath];
            }
        }
            break;
        default:
            break;
    }
}

-(void)showAlertView{
    
    if (self.usrModel.useMoeny.floatValue < 50) {
        UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"满50.00元即可提现，加油！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alerC addAction:sureAction];
        [self presentViewController:alerC animated:YES completion:nil];
        return;
    }

    if (self.usrModel.isSetPasswd.integerValue == 0) {
        UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲爱的用户，为了您的资金安全，您需要设置支付密码才能提现！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YMPaySecrectController* pvc = [[YMPaySecrectController alloc]init];
            pvc.setType = SetTypePayWordModify;
            pvc.title   = @"支付密码绑定";
            [self.navigationController pushViewController:pvc animated:YES];
        }];
        [alerC addAction:cancelAction];
        [alerC addAction:sureAction];
        [self presentViewController:alerC animated:YES completion:nil];
        return;
    }
}


@end
