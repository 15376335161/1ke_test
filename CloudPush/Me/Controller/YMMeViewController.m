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
#import "YMLoginController.h"


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
    
//    //处理导航 透明问题
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
    YMLoginController* mvc = [[YMLoginController alloc]init];
    mvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mvc animated:YES];
   // [self presentViewController:mvc animated:YES completion:nil];
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
#pragma mark -  按钮响应方法
-(void)setBtnClick:(UIButton* )btn{
    DDLog(@"设置按钮点击啦");
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
