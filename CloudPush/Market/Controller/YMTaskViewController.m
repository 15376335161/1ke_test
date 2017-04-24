//
//  YMTaskViewController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskViewController.h"
#import "YMTypeButton.h"
#import "YMTaskCell.h"
#import "YMTaskDetailController.h"
#import "UIImage+Extension.h"

@interface YMTaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray* titleArr;
//数据源
@property(nonatomic,strong)NSMutableArray* dataArr;

@property(nonatomic,strong)NSMutableArray* typeBtnsArr;

//表格
@property(nonatomic,strong)UITableView* tableView;

//分页
@property(nonatomic,assign)NSInteger page;
//存储参数
@property(nonatomic,strong)NSMutableDictionary* params;

@end

@implementation YMTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    //创建顶部View
    [self creatTopView];
    //请求数据
    [self requestDataWithPage:_page isLoading:YES type:@(self.type).stringValue param:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - lazy
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"剩余单数",@"截止日期",@"价格"];
    }
    return _titleArr;
}
-(NSMutableArray *)typeBtnsArr{
    if (!_typeBtnsArr) {
        _typeBtnsArr = [[NSMutableArray alloc]init];
    }
    return _typeBtnsArr;
}
//存储参数
-(NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
//请求数据
-(void)requestDataWithPage:(NSInteger)page isLoading:(BOOL)isLoading type:(NSString* )type param:(NSMutableDictionary* )oldParam{
    NSMutableDictionary* param ;
    NSArray* keys ;
    NSString* urlStr;
    if ([oldParam allKeys].count > 0) {
        param = [[NSMutableDictionary alloc]initWithDictionary:oldParam];
        keys =  [oldParam allKeys];
        urlStr = [NSString stringWithFormat:@"%@?type=%@&page=%ld&%@=%@",TaskListURL,type,(long)page,keys[0],oldParam[keys[0]]];
    }else{
        param = [[NSMutableDictionary alloc]init];
        urlStr = [NSString stringWithFormat:@"%@?type=%@&page=%ld",TaskListURL,type,(long)page];
    }
  //  NSMutableDictionary* param =
    // 剩余单数 surplu_nums=surplu_desc
    // 剩余单数 end_time=end_sort  end_desc
    // 剩余单数 surplu_price=price_sort  price_desc
    //排序
    //[param setValue:@"surplu_nums" forKey:@"surplu_desc"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    //[param setValue:@"surplu_desc" forKey:@"surplu_nums"];
    // [param setValue:@"surplu_desc" forKey:@"surplu_nums"];
    [param setObject:type forKey:@"type"];//23 - 27
    //pages=2&page=1&surplu_nums=surplu_desc
    // [param setValue:@"21" forKey:@"id_task"];
    YMWeakSelf;
    [[HttpManger sharedInstance]getHTTPReqAPI:urlStr params:param view:self.view isEdit:NO loading:isLoading tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        if (_page > 0 ) {
            if (responseObject[@"data"] == 0) {
                [MBProgressHUD showFail:@"已经是最后一页啦！" view:self.view];
            }
            NSMutableArray* allTmpArr = [[NSMutableArray alloc]init];
            NSArray* tmpArr = [YMTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [allTmpArr addObjectsFromArray:_dataArr];
            [allTmpArr addObjectsFromArray:tmpArr];
            _dataArr = allTmpArr;
        }else{
            weakSelf.dataArr = [YMTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - UI
-(void)creatTopView{
    UIView* topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    topView.backgroundColor = BackGroundColor;
    topView.sd_layout.leftEqualToView(self.view).topEqualToView(self.view).rightEqualToView(self.view).heightIs(50);

    UIButton* sortBtn = [Factory createButtonWithTitle:@"排序" frame:CGRectMake(0, 0, 60, 50 - 1) titleFont:14 textColor:LightGrayColor backgroundColor:WhiteColor target:self selector:@selector(sortBtnClick:)];
    [topView addSubview:sortBtn];
    
    UIView* lineView1 = [[UIView alloc]init];
    [topView addSubview:lineView1];
    lineView1.sd_layout.leftSpaceToView(sortBtn,0).topSpaceToView(topView,15).centerYEqualToView(topView).bottomSpaceToView(topView,15).widthIs(1);
    lineView1.backgroundColor = BackGroundColor;
    
    DDLog(@"width === %f",CGRectGetMaxX(lineView1.frame));
    
    CGFloat width = ( SCREEN_WIDTH -  CGRectGetWidth(sortBtn.frame) )/3;
    CGFloat heigh = 50 - 1;
    CGFloat  x    =   CGRectGetWidth(sortBtn.frame);
    for (int i = 0 ; i < self.titleArr.count; i ++) {
        YMTypeButton* btn = [[YMTypeButton alloc]initWithFrame:CGRectMake(x + width * i, 0,width , heigh) title:self.titleArr[i] imgStr:@"down_h"];
        btn.tag = i + 100;
        [self addTapGestureOnView:btn target:self selector:@selector(typeBtnClick:)];
       // [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btn];
        
        UIView* lineView2 = [[UIView alloc]init];
        [topView addSubview:lineView2];
        lineView2.backgroundColor = BackGroundColor;
        lineView2.sd_layout.topEqualToView(lineView1).xIs(x + width * i).widthIs(1).bottomEqualToView(lineView1);
        
        [self.typeBtnsArr addObject:btn];
    }
    //创建表格
    UITableView* tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,0).topSpaceToView(topView,0);
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = BackGroundColor;
    tableView.rowHeight = 10 * 2 + 75;
    self.tableView = tableView;
    //表尾
    self.tableView.tableFooterView = [UIView new];
#warning todo - 上下拉数据
    YMWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [weakSelf requestDataWithPage:_page isLoading:YES type:@(self.type).stringValue param:self.params];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ((_page + 1) * 15 > weakSelf.dataArr.count ) {
            [MBProgressHUD showFail:@"已经是最后一页啦！" view:self.view];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        ++ _page;
        DDLog(@"page = %ld",(long)_page);
        [weakSelf requestDataWithPage:_page isLoading:YES type:@(self.type).stringValue param:self.params];
    }];
}
-(void)sortBtnClick:(UIButton* )btn{
    DDLog(@"点击啦排序");
}
-(void)typeBtnClick:(UITapGestureRecognizer* )tap{
    //分页参数重置
    _page = 0;
     self.params = nil;
    //清空数据
    [self.dataArr removeAllObjects];
    DDLog(@"tag == %ld  点击啦类型按钮  _typeBtnsArr == %@  tap.view == %d",(long)tap.view.tag,_typeBtnsArr,tap.view.tag);
    YMTypeButton* btn =  (YMTypeButton* )tap.view;
    for (YMTypeButton* typeBtn in _typeBtnsArr) {
        if (tap.view.tag != typeBtn.tag) {
           // typeBtn.typeStatus = CustomTypeStatusUP;
            typeBtn.titlLabel.textColor = LightGrayColor;
           // typeBtn.imgView.image = [[UIImage alloc]imageWithColor:LightGrayColor];
           // typeBtn.imgView.image = [UIImage imageNamed:@"drop_hu"];//drop_hu.  down_h
            if (typeBtn.typeStatus == CustomTypeStatusUP) {
                 typeBtn.imgView.image = [UIImage imageNamed:@"drop_hu"];
            }else{
                typeBtn.imgView.image = [UIImage imageNamed:@"down_h"];//V
            }
        }else{
             btn.typeStatus = !btn.typeStatus;
        }
    }
    btn.titlLabel.textColor = NavBarTintColor;
    [UIView setAnimationDuration:0.3];
    btn.imgView.transform = CGAffineTransformRotate(btn.imgView.transform, M_PI_4 * 4);
    btn.imgView.image = [UIImage imageNamed:@"down_b"];
    [UIView commitAnimations];
   // btn.typeStatus = CustomTypeStatusDown;
    switch (btn.tag) {
        case 100:
        {
            if (btn.typeStatus == CustomTypeStatusUP) {
                
                self.params = [@{
                                @"surplu_nums":@"surplu_sort"
                                }mutableCopy];
            }else{
                self.params = [@{
                                 @"surplu_nums":@"surplu_desc"
                                 }mutableCopy];
            }
            [self requestDataWithPage:0 isLoading:YES type:@(self.type).stringValue param:self.params];
            DDLog(@"剩余单数  typeStatus == %ld",(long)btn.typeStatus);
        }
            break;
        case 101:
        {
            if (btn.typeStatus == CustomTypeStatusUP) {
                self.params = [@{
                                 @"end_time":@"end_sort"
                                 }mutableCopy];
            }else{
                self.params = [@{
                                 @"end_time":@"end_desc"
                                 }mutableCopy];
            }
            [self requestDataWithPage:0 isLoading:YES type:@(self.type).stringValue param:self.params];

            DDLog(@"截止日期 typeStatus == %ld",(long)btn.typeStatus);
        }
            break;
        case 102:
        {
            if (btn.typeStatus == CustomTypeStatusUP) {
                self.params = [@{
                                 @"price":@"price_sort"
                                 }mutableCopy];
            }else{
                self.params = [@{
                                 @"price":@"price_desc"
                                 }mutableCopy];
            }
            [self requestDataWithPage:0 isLoading:YES type:@(self.type).stringValue param:self.params];
            DDLog(@"价格 typeStatus == %ld",(long)btn.typeStatus);
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMTaskCell *cell = [YMTaskCell cellDequeueReusableCellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self requestTaskDetailByModel:_dataArr[indexPath.row]];
}

-(void)requestTaskDetailByModel:(YMTaskModel*)model{
    YMWeakSelf;
    [[HttpManger sharedInstance]getHTTPReqAPI:[NSString stringWithFormat:@"%@?id_task=%@",TaskDetailURL,model.id.stringValue] params:@{@"id_task":model.id.stringValue} view:self.view isEdit:NO  loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        YMTaskDetailController* tvc = [[YMTaskDetailController alloc]init];
        tvc.title = @"任务详情";
        tvc.hidesBottomBarWhenPushed = YES;
        tvc.model = model;
        [weakSelf.navigationController pushViewController:tvc animated:YES];
    }];
}

@end
