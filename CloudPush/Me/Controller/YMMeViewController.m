//
//  YMMeViewController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeViewController.h"
#import "YMMeIconCell.h"
#import "YMTitleCell.h"
#import "UIImage+Extension.h"

#import "YMTeamListController.h"
#import "YMWalletController.h"
#import "YZTShareController.h"
#import "YMMsgListController.h"
#import "YMFeedBackController.h"
#import "YMSetController.h"


@interface YMMeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
     UIImageView *navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//去掉导航
@property(nonatomic,strong)UIImageView* barImageView;

@property(nonatomic,strong)NSArray* titileArr;
@property(nonatomic,strong)NSArray* iconArr;

@end

@implementation YMMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   //处理导航 透明问题
   //  _barImageView = self.navigationController.navigationBar.subviews.firstObject;
   //  _barImageView.alpha = 0;
    
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = NavBarTintColor;

    YMMeIconCell* cell = [YMMeIconCell shareCell];
    self.tableView.tableHeaderView = cell;
    
   UIButton* rightBarBtn = [Factory createNavBarButtonWithImageStr:@"my_set up" target:self selector:@selector(setBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (_barImageView ) {
//        _barImageView = self.navigationController.navigationBar.subviews.firstObject;
//        _barImageView.alpha = 0;
//    }
    //方式一
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
     //再定义一个imageview来等同于这个黑线
     navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
     navBarHairlineImageView.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //恢复之前的导航色
    // _barImageView.alpha = 1;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMTitleCell* cell = [YMTitleCell cellDequeueReusableCellWithTableView:tableView];
    if (indexPath.section == 0) {
        [cell cellWithTitle:self.titileArr[indexPath.row] icon:self.iconArr[indexPath.row]];
        
    }
    if (indexPath.section == 1) {
         [cell cellWithTitle:self.titileArr[indexPath.row + 3] icon:self.iconArr[indexPath.row + 3]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 7;
    }else{
        return 0;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"点击啦 某一行");
    if ([[YMUserManager shareInstance] isValidLogin]) {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    [self requestUserData];
                }else if (indexPath.row == 1){
                    YMTeamListController* tvc = [[YMTeamListController alloc]init];
                    tvc.title = @"团队列表";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }else{
                    YZTShareController* tvc = [[YZTShareController alloc]init];
                    tvc.title = @"我的邀请";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }
                
            }
                break;
            case 1:
            {
                if (indexPath.row == 0) {
                    YMMsgListController* pvc = [[YMMsgListController alloc]init];
                    pvc.title = @"消息中心";
                    pvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:pvc animated:YES];
                }else if (indexPath.row == 1){
                    YMFeedBackController* tvc = [[YMFeedBackController alloc]init];
                    tvc.title = @"意见反馈";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }
            }
                break;
            default:
                break;
        }
    //未登录跳转到登录
    }else{
        [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)requestUserData{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"1422" forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];//@"4a70ef79952fbb9cd62eefd0edc139a6"
    
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        YMWalletController* pvc = [[YMWalletController alloc]init];
        pvc.title = @"钱包";
        pvc.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        //存储用户信息
        [[YMUserManager shareInstance] saveUserInfoByUsrModel:pvc.usrModel];
        pvc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:pvc animated:YES];
              
    }];
    
//    YMWalletController* pvc = [[YMWalletController alloc]init];
//    pvc.title = @"钱包";
//   // pvc.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
//    //存储用户信息
//    [[YMUserManager shareInstance] saveUserInfoByUsrModel:pvc.usrModel];
//    pvc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:pvc animated:YES];

}
#pragma mark -  按钮响应方法
-(void)setBtnClick:(UIButton* )btn{
    DDLog(@"设置按钮点击啦");
    YMSetController* svc = [[YMSetController alloc]init];
    svc.title = @"设置";
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark - lazy
-(NSArray *)titileArr{
    if (!_titileArr) {
        _titileArr = @[@"钱包",@"我的团队",@"我的邀请",@"消息中心",@"意见反馈"];
    }
    return _titileArr;
}

-(NSArray *)iconArr{
    if (!_iconArr) {
        _iconArr = @[@"my_wallet",@"my_team",@"my_letter",@"my_new",@"my_opinion"];
    }
    return _iconArr;
}


@end
