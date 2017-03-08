//
//  YMReceSuccessController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMReceSuccessController.h"
#import "YMCommissionCell.h"
#import "YMTaskTitleCell.h"
#import "YMReceFootCell.h"
#import "YMReceHeadCell.h"


@interface YMReceSuccessController ()<UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMReceSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLog(@"model == %@  taskCOunt == %@  mytaskList == %@  status == %@",self.model,self.model.myTaskCounts,self.model.myTaskList,self.model.myTaskStatus);
    
    YMReceHeadCell* headCell = [YMReceHeadCell shareCell];
   // headCell.model = self.model;
    
    headCell.outTimeLabel.text = [NSString stringWithFormat:@"截止日期：%@",_dicData[@"myTaskList"][@"end_time"]];
    headCell.leftCountLabel.text = [NSString stringWithFormat:@"剩余单数：%d",([_dicData[@"myTaskList"][@"task_nums"] intValue] - [_dicData[@"myTaskList"][@"COUNT(id)"] intValue] )];
    //headCell.
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
        return 2;
    }else{
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                YMTaskTitleCell * cell = [YMTaskTitleCell shareCell];
                // cell.model = self.model;
                [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:@"imgPath"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                 cell.titlLabel.text = self.dicData[@"myTaskList"][@"task_title"];
                return cell;
            }else{
                YMCommissionCell * cell = [YMCommissionCell shareCell];
                cell.commissionLabel.text = [NSString stringWithFormat:@"佣金：¥%@元／单",self.dicData[@"myTaskList"][@"price"]];
                [YMTool labelColorWithLabel:cell.commissionLabel font:Font(14) range:NSMakeRange(3, cell.commissionLabel.text.length - 3)  color:NavBarTintColor];
                return cell;
            }
        }
            break;
        case 1:
        {
            YMReceFootCell* cell = [YMReceFootCell shareCell];
            //去掉分割线
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
            return cell;
        }
        default:
            return nil;
            break;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 40;
        }
            break;
        case 1:
        {
            //计算高度
            return 83;
        }
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 7;
    }else{
        return 0;
    }
}
@end
