//
//  YMWithdrawStyleController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawStyleController.h"
#import "YMWithdrawStyleCell.h"
#import "YMWithdrawController.h"
#import "YMPaySecrectController.h"


@interface YMWithdrawStyleController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//标注 tag -- 类型  type == @1 不会跳转到 提现界面  跳转到 为0 提现界面
//@property(nonatomic,assign)NSInteger type;
//类型
@property(nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation YMWithdrawStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    //表尾
    self.tableView.tableFooterView = [UIView new];

    //初始化数据
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
        model.icon  = @"alipayUnset";
        model.isZfb = @0;
        model.title = @"绑定支付宝账号提现";
        [self.dataArr addObject:model];
    }
    if (self.usrModel.isZfb.integerValue) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon  = @"alipay";
        model.title = @"支付宝";
        model.isZfb = @1;
        model.withdrawStyle = self.withdrawStyle;
         
        [self.dataArr addObject:model];
    }
    if (self.usrModel.isCard.integerValue == 0) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon   = @"disabled_without_bank-card";
        model.isCard = @0;
        model.title  = @"绑定银行卡提现";
        [self.dataArr addObject:model];
    }
    if (self.usrModel.isCard.integerValue) {
        TitleModel* model = [[TitleModel alloc]init];
        model.icon =   @"Unionpay";
        model.title =  @"银行卡";
        model.withdrawStyle = self.withdrawStyle;
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
        if (self.typeBlock) {
            self.typeBlock(WithDrawCrashStyleZfb,model);
        }
        [self.navigationController popViewControllerAnimated:YES];

    }else if (model.isCard.integerValue){
        if (self.typeBlock) {
            self.typeBlock(WithDrawCrashStyleBankCard,model);
        }
        [self.navigationController popViewControllerAnimated:YES];
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

@end
