//
//  YMMsgDetailController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMsgDetailController.h"
#import "YMMsgDetailCell.h"
#import "UIBarButtonItem+HKExtension.h"

@interface YMMsgDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMMsgDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.model = [[YMMsgModel alloc]init];
    self.model.content = @"哈哈减肥啦啊发酵；发 啦放假啦发几个拉萨了张家口 v 拉萨布局啊邻居啊世界杯 v 了就啦赶紧送表格啦就是个垃圾股 i 哦啦就是光荣 i 诶基本 v了竟然公然举办借款人规律就是大肉包裤薄但是人家奔跑疾病";
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"del" target:self action:@selector(deleteMsgClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)deleteMsgClick:(UIButton* )btn{
    DDLog(@"删除了按钮");
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMMsgDetailCell * cell = [YMMsgDetailCell shareCell];
    cell.model = self.model;
    cell.selectionStyle           = UITableViewCellSelectionStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - text height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 + self.model.textHeight;
}

@end
