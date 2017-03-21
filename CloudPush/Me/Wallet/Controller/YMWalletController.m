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


@interface YMWalletController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMWalletController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    
    YMWalletHeadCell* cell = [YMWalletHeadCell shareCell];
    cell.model = self.usrModel;
    self.tableView.tableHeaderView = cell;
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
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //恢复之前的导航色
    navBarHairlineImageView.hidden = NO;
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
-(void)requestUserData{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"1422" forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];//@"4a70ef79952fbb9cd62eefd0edc139a6"
    
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        weakSelf.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [[YMUserManager shareInstance] saveUserInfoByUsrModel:weakSelf.usrModel];
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
    
    YMSpecTitleCell* cell = [YMSpecTitleCell cellDequeueReusableCellWithTableView:tableView];
    YMWeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                YMSetTitileCell* cell = [YMSetTitileCell cellDequeueReusableCellWithTableView:tableView];
                cell.titlLabel.text = @"提现";
                return cell;
            }else{
                cell.titlLabel.text = @"支付密码";
                cell.actionBlock = ^(UIButton * btn){
                    DDLog(@"修改 设置支付密码");
                    [weakSelf pushToViewController:[YMPaySecrectController alloc] userModel:weakSelf.usrModel indexPath:indexPath];
                };
                if (self.usrModel.isSetPasswd.integerValue) {
                    [cell.actionBtn setTitle:@"更改" forState:UIControlStateNormal];
                }else{
                    [cell.actionBtn setTitle:@"设置" forState:UIControlStateNormal];
                }
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.titlLabel.text = @"支付宝";
                cell.actionBlock = ^(UIButton * btn){
                    DDLog(@"修改 设置支付密码");
                   [weakSelf pushToViewController:[YMPaySecrectController alloc] userModel:weakSelf.usrModel indexPath:indexPath];
                };
                if (self.usrModel.isZfb.integerValue) {
                    [cell.actionBtn setTitle:@"更改" forState:UIControlStateNormal];
                }else{
                    [cell.actionBtn setTitle:@"设置" forState:UIControlStateNormal];
                }
            }else{
                cell.titlLabel.text = @"银联";
                cell.actionBlock = ^(UIButton * btn){
                    DDLog(@"修改 设置银联");
                    [weakSelf pushToViewController:[YMPaySecrectController alloc] userModel:weakSelf.usrModel indexPath:indexPath];
                };
                if (self.usrModel.isCard.integerValue) {
                    [cell.actionBtn setTitle:@"更改" forState:UIControlStateNormal];
                }else{
                    [cell.actionBtn setTitle:@"设置" forState:UIControlStateNormal];
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
            vc.title = @"更改支付密码";
            vc.setType = SetTypePayWordModify;
        }else{
            vc.title = @"支付密码绑定";
            vc.setType = SetTypePayWordUnSet;
        }
        vc.refreshDataBlock = ^(){
            [weakSelf requestUserData];
        };
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            YMPaySecrectController * vc  = (YMPaySecrectController *)viewController;
            if (usrModel.isZfb.integerValue) {
                vc.title = @"更改支付宝";
                 vc.setType = SetTypeZhiFuBaoModify;
//                vc.firstTitle  = @"支付宝账号";
//                vc.secondTitle = @"真实姓名";
            }else{
                vc.title = @"支付宝绑定";
                vc.setType = SetTypeZhiFuBaoUnSet;
//                vc.firstTitle  = @"支付宝账号";
//                vc.secondTitle = @"真实姓名";
            }
            vc.refreshDataBlock = ^(){
                [weakSelf requestUserData];
            };
        }else{
            YMPaySecrectController * vc  = (YMPaySecrectController *)viewController;
            if (usrModel.isCard.integerValue) {
                vc.title = @"更改银行卡";
                 vc.setType = SetTypeBankCardModify;
            }else{
                vc.title = @"银行卡绑定";
                vc.setType = SetTypeBankCardUnSet;
            }
            vc.refreshDataBlock = ^(){
                [weakSelf requestUserData];
            };
        }
    }
    [self.navigationController pushViewController:viewController animated:YES];
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
                YMWithdrawStyleController* mvc = [[YMWithdrawStyleController alloc]init];
                mvc.title = @"选择提现方式";
                mvc.usrModel = self.usrModel;
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

@end
