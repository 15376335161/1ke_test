//
//  YMSetController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMSetController.h"
#import "YMSetTitileCell.h"
#import "YMSignOutCell.h"
#import "YMForgetFirstController.h"
#import "YMForgetViewController.h"
#import "YMSetPhoneController.h"
#import "YMRegistWebController.h"


@interface YMSetController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMSetTitileCell *cell = [YMSetTitileCell cellDequeueReusableCellWithTableView:tableView];
    switch (indexPath.section) {
        case 0:
            cell.titlLabel.text = @"修改密码";
            break;
        case 1:
            cell.titlLabel.text = @"密保手机";
            break;
        case 2:
        {
            YMSignOutCell* cell = [YMSignOutCell cellDequeueReusableCellWithTableView:tableView];
            //去掉分割线
            YMWeakSelf;
            cell.signOutBlock = ^(UIButton* signOutBtn){
                DDLog(@"退出登录");
                [[YMUserManager shareInstance]removeUserInfo];
                [kUserDefaults setBool:NO forKey:kisRefresh];
                [kUserDefaults synchronize];
                if (weakSelf.backToMainBlock) {
                    weakSelf.backToMainBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[YMUserManager shareInstance] isValidLogin]) {
        if (indexPath.section == 0) {
            YMForgetViewController* fvc = [[YMForgetViewController alloc]init];
            fvc.title = @"修改密码";
            fvc.passwordType = PasswordTypeModify;
            [self.navigationController pushViewController:fvc animated:YES];
        }
        //密保手机
        if (indexPath.section == 1) {
            YMSetPhoneController* svc = [[YMSetPhoneController alloc]init];
            svc.title = @"密保手机";
            [self.navigationController pushViewController:svc animated:YES];
        }
        
        //推出登录
        else if (indexPath.section == 2){
            DDLog(@"退出登录");
            [[YMUserManager shareInstance]removeUserInfo];
            [kUserDefaults setBool:NO forKey:kisRefresh];
            [kUserDefaults synchronize];
            if (self.backToMainBlock) {
                self.backToMainBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
}

@end
