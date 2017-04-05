//
//  MyTasksViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "MyTasksViewController.h"
#import "YMMyTaskCell.h"
#import "YMTaskInvalidCell.h"
#import "YMTaskCheckCell.h"
#import "YMMYTaskDetailController.h"
#import "YMTaskStatusModel.h"


@interface MyTasksViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据源
@property(nonatomic,strong)NSMutableArray* dataArr;
//个数数据源
@property(nonatomic,strong)NSMutableArray* countArr;

@end

@implementation MyTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLog(@"self.tag == %ld",(long)self.tag);
    //表尾
    self.tableView.tableFooterView = [UIView new];
    [self requestDataByTag:self.tag];
    //设置行高
    switch (self.tag) {
        case 0:
        {
            self.tableView.rowHeight = 121 ;
        }
            break;
        case 1:
            self.tableView.rowHeight = 121 ;
            break;
        case 2:
            self.tableView.rowHeight = 121 ;
            break;
        case 3:
            self.tableView.rowHeight = 75 ;
            break;
        default:
            break;
    }
    
    YMWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataByTag:weakSelf.tag];
    }];
    
}

-(void)requestDataByTag:(NSInteger)tag{
    NSString* urlStr ;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    if ([[YMUserManager shareInstance] isValidLogin]) {
         [param setObject:@"1422" forKey:@"user_id"];//[kUserDefaults valueForKey:kUid]
        if (tag == 0) {
            urlStr = MyTaskListPending;
        }else if (tag == 1){
            urlStr = MyTaskListAudit;
        }else if (tag == 2){
            urlStr = MyTaskListSuccess;
        }else if (tag == 3){
            urlStr = MyTaskListFailed;
        }
        YMWeakSelf;
        [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
            
            if (self.tag != 3) {
                YMTaskStatusModel* statusModel =  [YMTaskStatusModel mj_objectWithKeyValues:responseObject[@"data"]];
                if (weakSelf.tag == 0) {
                    weakSelf.dataArr = [statusModel.taskProject mutableCopy];
                    weakSelf.countArr = [statusModel.pending mutableCopy];
                    DDLog(@"0   ===     dataArr == %@ ",self.dataArr);
                    
                }else if (weakSelf.tag == 1){
                     weakSelf.dataArr = [statusModel.audit mutableCopy];
                     weakSelf.countArr = [statusModel.audit_count mutableCopy];
                     DDLog(@"1   ===     dataArr == %@ ",self.dataArr);
                }else if (weakSelf.tag == 2){
                    weakSelf.dataArr = [statusModel.success mutableCopy];
                    weakSelf.countArr = [statusModel.orderSuccess mutableCopy];
                     DDLog(@"2   ===     dataArr == %@ ",self.dataArr);
                }
            }
            
           if (weakSelf.tag == 3){
               self.dataArr = [YMTaskStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
           }
           [self.tableView reloadData];
        }];
    }else{
        //停止刷新
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
         [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;//self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 3) {
        YMTaskInvalidCell* cell = [YMTaskInvalidCell cellDequeueReusableCellWithTableView:tableView];
        cell.model = self.dataArr[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (self.tag == 0) {
        YMMyTaskCell* cell = [YMMyTaskCell cellDequeueReusableCellWithTableView:tableView];
        cell.model = self.dataArr[indexPath.section];
        cell.countModel = self.countArr[indexPath.section];
        cell.actionBlock = ^(UIButton * btn){
            
            DDLog(@"按钮 tag == %ld",(long)btn.tag);
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //审核中。审核完成
    YMTaskCheckCell* cell = [YMTaskCheckCell cellDequeueReusableCellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.section];
    cell.countModel = self.countArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//提交任务
-(void)updateTaskWithIndexPath:(NSIndexPath* )indexPath{
    
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}

#pragma mark - UITableViewDelegte
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"cell 点击了某一行");
    YMMYTaskDetailController* mvc = [[YMMYTaskDetailController alloc]init];
    mvc.title = @"任务详情";
    mvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mvc animated:YES];
}

@end
