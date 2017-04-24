//
//  MyTasksViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "MyTasksViewController.h"
#import "YMMyTaskCell.h"
#import "YMMYTaskDetailController.h"
#import "YMTaskStatusModel.h"
#import "YMTaskInfoCell.h"
#import "UIView+Placeholder.h"


@interface MyTasksViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//数据源
@property(nonatomic,strong)NSMutableArray* dataArr;

//占位
@property(nonatomic,strong)UIView* placeView;
@end

@implementation MyTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLog(@"self.tag == %ld",(long)self.tag);
    //表尾
    YMTaskInfoCell* footCell = [YMTaskInfoCell shareCell];
    footCell.titleLabel.text = @"1、参与记录需等第三方平台回调记录，一般会在参与后1～3个工作日更新，请耐心等待；\n2、审核周期为7天";
     CGFloat textHeight = [YMHeightTools heightForText:footCell.titleLabel.text fontSize:13 width:SCREEN_WIDTH - 15 * 2];
    footCell.sd_layout.heightIs(15 + 15 + 13 + textHeight + 10);
    self.tableView.tableFooterView = footCell;
    
    [self requestDataByTag:self.tag];
    //设置行高
    switch (self.tag) {
        case 0:
        {
            self.tableView.rowHeight = 144 - 18 - 9 + 5 ;
        }
            break;
        case 1:
            self.tableView.rowHeight = 144 - 18 - 9 + 5 ;
            break;
        case 2:
            self.tableView.rowHeight = 185 - 8.5 - 18 - 9 + 5 ;
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
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    if ([[YMUserManager shareInstance] isValidLogin]) {
         [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
         [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
        if (tag == 0) {
            [param setObject:@"1" forKey:@"type"];
        }else if (tag == 1){
            [param setObject:@"2" forKey:@"type"];
        }else if (tag == 2){
            [param setObject:@"3" forKey:@"type"];
        }
        YMWeakSelf;
        [[HttpManger sharedInstance]callHTTPReqAPI:AuditListURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {

            weakSelf.dataArr = [YMTaskStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"audit"]];
            //显示占位
            weakSelf.placeView.hidden = weakSelf.dataArr.count;
            [weakSelf.tableView reloadData];
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
    YMMyTaskCell* cell = [YMMyTaskCell cellDequeueReusableCellWithTableView:tableView];
    if (_tag == 2) {
        cell.resonLabel.hidden = NO;
    }else{
        cell.resonLabel.hidden = YES;
    }
    cell.model = self.dataArr[indexPath.section];
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

-(UIView *)placeView{
    if (!_placeView) {
        _placeView = [UIView placeViewWhithFrame:self.tableView.frame placeImgStr:@"iconPlaceholder" placeString:@"暂无记录！"];
        [self.view addSubview:_placeView];
        _placeView.hidden = YES;
    }
    return _placeView;
}

//#pragma mark - UITableViewDelegte
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DDLog(@"cell 点击了某一行");
//    YMMYTaskDetailController* mvc = [[YMMYTaskDetailController alloc]init];
//    mvc.title = @"任务详情";
//    mvc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:mvc animated:YES];
//}

@end
