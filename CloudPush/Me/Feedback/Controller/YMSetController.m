//
//  YMSetController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSetController.h"
#import "YMSetTitileCell.h"
#import "YMSignOutCell.h"
#import "YMForgetFirstController.h"
#import "YMForgetViewController.h"


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
    return 4;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMSetTitileCell *cell = [YMSetTitileCell cellDequeueReusableCellWithTableView:tableView];
    switch (indexPath.section) {
        case 0:
            cell.titlLabel.text = @"设置头像";
            break;
        case 1:
            cell.titlLabel.text = @"修改密码";
            break;
        case 2:
            cell.titlLabel.text = @"密保手机";
            break;
        case 3:
        {
            YMSignOutCell* cell = [YMSignOutCell cellDequeueReusableCellWithTableView:tableView];
            //去掉分割线
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
            cell.signOutBlock = ^(UIButton* signOutBtn){
                DDLog(@"退出登录");
                [[YMUserManager shareInstance]removeUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
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
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
        {
            YMForgetViewController* fvc = [[YMForgetViewController alloc]init];
            fvc.title = @"修改密码";
            fvc.passwordType = PasswordTypeModify;
            [self.navigationController pushViewController:fvc animated:YES];
        }
            break;
        case 2:
           
            break;
        case 3:
        {
            YMSignOutCell* cell = [YMSignOutCell cellDequeueReusableCellWithTableView:tableView];
            cell.signOutBlock = ^(UIButton* signOutBtn){
                DDLog(@"退出登录");
                [[YMUserManager shareInstance]removeUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
            break;
        default:
            break;
    }

    
}

@end
