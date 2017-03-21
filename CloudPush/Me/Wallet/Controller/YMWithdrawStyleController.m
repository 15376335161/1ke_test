//
//  YMWithdrawStyleController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawStyleController.h"
#import "YMWithdrawStyleCell.h"
#import "TitleModel.h"
#import "YMWithdrawController.h"
#import "YMPaySecrectController.h"


@interface YMWithdrawStyleController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
////标题
//@property(nonatomic,strong)NSMutableArray* titlArr;
////图标
//@property(nonatomic,strong)NSMutableArray* iconArr;

////标注 tag -- 类型  type == @1 不会跳转到 提现界面  跳转到 为0 提现界面
//@property(nonatomic,assign)NSInteger type;
//类型
@property(nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation YMWithdrawStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    //表尾
    self.tableView.tableFooterView = [UIView new];
    
    self.usrModel = [[UserModel alloc]init];
    self.usrModel.isZfb = @1;
    self.usrModel.isCard = @1;
    self.usrModel.readyMoney = @"20";
    self.usrModel.useMoeny   = @"120";
    self.usrModel.grandTotalMoeny = @"300";
    self.usrModel.isZfb_realName = @"dy";
    self.usrModel.isZfb_accountName = @"15376335161";
    self.usrModel.isCard_realName = @"dy";
    self.usrModel.isCard_accountName = @"15376335161";
    
    [self setUpData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setUpData{
    if (self.usrModel.isZfb.integerValue == 0) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon = @"wechat";
        model.isZfb = @0;
        model.title = @"绑定支付宝账号提现";
        [self.dataArr addObject:model];
    }
    if (self.usrModel.isZfb.integerValue) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon = @"wechat";
        model.title = @"支付宝";
        model.isZfb = @1;
        [self.dataArr addObject:model];
    }
    if (self.usrModel.isCard.integerValue == 0) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon = @"wechat";
        model.isCard = @0;
        model.title = @"绑定银行卡提现";
        [self.dataArr addObject:model];
    }
    
    if (self.usrModel.isCard.integerValue) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon = @"wechat";
        model.title = @"银行卡";
        model.isCard = @1;
        [self.dataArr addObject:model];
    }

    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWithdrawStyleCell* cell = [YMWithdrawStyleCell cellDequeueReusableCellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    TitleModel* model = self.dataArr[indexPath.section];
    if (model.isZfb.integerValue) {
        YMWithdrawController* mvc = [[YMWithdrawController alloc]init];
        mvc.title = @"提现";
        mvc.usrModel = self.usrModel;
        mvc.model = self.dataArr[indexPath.section];
        mvc.withdrawStyle = WithDrawCrashStyleZfb;
        [self.navigationController pushViewController:mvc animated:YES];
    }else if (model.isCard.integerValue){
        YMWithdrawController* mvc = [[YMWithdrawController alloc]init];
        mvc.title = @"提现";
        mvc.usrModel = self.usrModel;
        mvc.model = self.dataArr[indexPath.section];
        mvc.withdrawStyle = WithDrawCrashStyleBankCard;
        [self.navigationController pushViewController:mvc animated:YES];
    }else  if(model.isZfb.integerValue == 0 && [model.title isEqualToString:@"绑定支付宝账号提现"]){
        YMPaySecrectController* pvc = [[YMPaySecrectController alloc]init];
        pvc.title = @"绑定支付宝";
        pvc.setType = SetTypeZhiFuBaoUnSet;
        
        [self.navigationController pushViewController:pvc animated:YES];
    }else if(model.isCard.integerValue == 0 && [model.title isEqualToString:@"绑定银行卡提现"]){
        YMPaySecrectController* pvc = [[YMPaySecrectController alloc]init];
        pvc.title = @"绑定银行卡";
        pvc.setType = SetTypeBankCardUnSet;
        
        [self.navigationController pushViewController:pvc animated:YES];
    }
    
}
#pragma mark - lazy
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
//-(NSMutableArray *)titlArr{
//    if (!_titlArr) {
//        _titlArr = [[NSMutableArray alloc]init];
//    }
//    return _titlArr;
//}
//-(NSMutableArray *)iconArr{
//    if (!_iconArr) {
//        _iconArr = [[NSMutableArray alloc]init];
//    }
//    return _iconArr;
//}

@end
