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


@interface MyTasksViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据源
@property(nonatomic,strong)NSMutableArray* dataArr;

@end

@implementation MyTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLog(@"self.tag == %ld",(long)self.tag);
    //表尾
    self.tableView.tableFooterView = [UIView new];
    //设置行高
    switch (self.tag) {
        case 0:
            self.tableView.rowHeight = 121 ;
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
   // self.tableView.rowHeight = 121 ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (self.tag == 0) {
        YMMyTaskCell* cell = [YMMyTaskCell cellDequeueReusableCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //审核中。审核完成
    YMTaskCheckCell* cell = [YMTaskCheckCell cellDequeueReusableCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

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
