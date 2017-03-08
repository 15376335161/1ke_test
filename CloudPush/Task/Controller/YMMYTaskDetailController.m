//
//  YMMYTaskDetailController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMYTaskDetailController.h"
#import "YMTaskHeadCell.h"
#import "YMContentCell.h"
#import "YMDescContentCell.h"


@interface YMMYTaskDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//中间数组
@property(nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation YMMYTaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //表格
    YMTaskHeadCell* headCell = [YMTaskHeadCell shareCell];
    self.tableView.tableHeaderView = headCell;
    
    self.tableView.tableFooterView = [UIView new];
 
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
        return  5;//self.dataArr.count;
    }
    return 1;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            YMContentCell* cell = [YMContentCell cellDequeueReusableCellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                
            }else{
                 cell.titlLabel.textColor = HEX(@"666666");
            }
            return cell;
        }
            break;
        case 1:
        {
            YMDescContentCell* cell = [YMDescContentCell shareCell];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
       
        default:
            return nil;
            break;
    }
}

//分隔线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }else{
        //待定 需要计算。 业务概要。审核标准 等
        return 100;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
////预加载
//if (indexPath.row == _dataArr.count - 3) {
//    [self.tableView.mj_footer beginRefreshing];
//    // [self requestDataByPage:_nextPage is_new_product:self.is_new_product];
//}
@end
