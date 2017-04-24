//
//  YMWithdrawDetailController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawDetailController.h"
#import "YMWithdrawModel.h"
#import "YMWithdrawDetailCell.h"
#import "YMSectionCell.h"
#import "YMBalanceCell.h"
#import "UIView+Placeholder.h"


@interface YMWithdrawDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据源
@property(nonatomic,strong)NSMutableArray* dataArr;

//标题数组
@property(nonatomic,strong)NSMutableArray* titlArr;

@property(nonatomic,strong)UIView* placeView;
@end

@implementation YMWithdrawDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 51;
    
    //请求数据
    [self requestDataListWithType:self.detailListType];
    
}
-(void)requestDataListWithType:(DetailListType)type{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];  //
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    NSString* urlStr ;
    if (type == DetailListTypeBalance) {
        urlStr = ChangeMoneyLogURL;
    }else if (type == DetailListTypeWithdraw){
        urlStr = ExtractRecordListURL;
    }else if (type == DetailListTypeWaitIssue){
        urlStr = WaitingListURL;
    }
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:_tableView completionHandler:^(id task, id responseObject, NSError *error) {
        DDLog(@"提现明细");
        for (NSArray* tmpDataArr in responseObject[@"data"]) {
             NSMutableArray* tmpArr = [YMWithdrawModel mj_objectArrayWithKeyValuesArray:tmpDataArr];
             [weakSelf.dataArr addObject:tmpArr];
        }
       // int j = 0;
        for (NSArray* tmpDataArr in weakSelf.dataArr) {
            for (int i = 0; i < tmpDataArr.count; i ++) {
                YMWithdrawModel* model = tmpDataArr[i];
                if (model.month && ![weakSelf.titlArr containsObject: model.month]) {
                    [weakSelf.titlArr addObject:model.month];
                    DDLog(@"titlArr == %@",weakSelf.titlArr);
        //            DDLog(@"i == %d",j);
                    continue;
                }
          //      j ++;
            }
        }
        weakSelf.placeView.hidden = weakSelf.dataArr.count;
        [weakSelf.tableView reloadData];
    }];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(NSMutableArray *)titlArr{
    if (!_titlArr) {
        _titlArr = [[NSMutableArray alloc]init];
    }
    return _titlArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* tmpArr = self.dataArr[section];
    return tmpArr.count;
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.detailListType == DetailListTypeWithdraw) {
        YMWithdrawDetailCell* cell = [YMWithdrawDetailCell shareCellWithTableView:tableView];
         cell.model = self.dataArr[indexPath.section][indexPath.row];
        return cell;
    }else{
        YMBalanceCell* cell = [YMBalanceCell shareCellWithTableView:tableView];
         cell.model = self.dataArr[indexPath.section][indexPath.row];
        return cell;
    }

}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}
-(UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YMSectionCell* headCell = [YMSectionCell cellDequeueReusableCellWithTableView:tableView];
    if (self.titlArr.count > section) {
         headCell.titlLabel.text = self.titlArr[section];
    }
    return headCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

-(UIView *)placeView{
    if (!_placeView) {
        _placeView = [UIView placeViewWhithFrame:self.tableView.frame placeImgStr:@"iconPlaceholder" placeString:@"暂无记录！"];
        [self.view addSubview:_placeView];
        _placeView.hidden = YES;
    }
    return _placeView;
}
@end
