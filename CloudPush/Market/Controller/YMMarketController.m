//
//  YMMarketController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMarketController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "YMTool.h"
#import "YMLocationButton.h"
#import "YMTaskCell.h"
#import "MainItemCell.h"
#import "MainItemButton.h"
#import "YMTaskViewController.h"
#import "YMTaskDetailController.h"
#import "YMTaskModel.h"



@interface YMMarketController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>

//页数
@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;
//左右边的按钮
@property(nonatomic,strong)YMLocationButton* locationBtn;
@property(nonatomic,strong)UIButton* messageBtn;
@property(nonatomic,strong)UILabel* mesgNumLabel;
//表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* dataArr;
@property(nonatomic,strong)NSArray* titleArr;
@property(nonatomic,strong)NSArray* imgsArr;
@end

@implementation YMMarketController

- (void)viewDidLoad {
    [super viewDidLoad];

   // 启动LocationService
    [self.locService startUserLocationService];
    //创建定位按钮
    [self creatTopLocationItem];
    //创建消息中心
    [self creatRightItem];
    //设置表格数据
    [self modifyTableView];
    
    _page = 0;
    //请求数据
    [self requestDataWithPage:_page isLoading:YES type:@""];
    
    YMWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [weakSelf requestDataWithPage:_page isLoading:YES type:@""];
        
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
        [weakSelf requestDataWithPage:_page isLoading:YES type:@""];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_locationBtn) {
        _locationBtn.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil;//不用的时候需要置nil，否则影响内存的释放
    
     _locationBtn.hidden = YES;
}
-(void)dealloc{
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//请求数据
-(void)requestDataWithPage:(NSInteger)page isLoading:(BOOL)isLoading type:(NSString* )type{
    //192.168.10.31
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [param setObject:type forKey:@"type"];//23- 27
    YMWeakSelf;
    [[HttpManger sharedInstance]getHTTPReqAPI:[NSString stringWithFormat:@"%@?type=%@&page=%ld",TaskListURL,type,(long)page] params:param view:self.view loading:isLoading tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
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
        [weakSelf modifyTableView];
    }];
}
#pragma mark - 消息中心
-(void)creatRightItem{
    self.messageBtn = [Factory createNavBarButtonWithImageStr:@"news" target:self selector:@selector(messageBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_messageBtn];
    
    _mesgNumLabel = [Factory createCircleLabelWithFrame:CGRectMake(CGRectGetWidth(_messageBtn.frame) - 5 , -5, 14, 14) text:@"9" textColor:WhiteColor fontSize:10 bgColor:RedColor borderColor:RedColor borderWidth:1];
     [_messageBtn addSubview:_mesgNumLabel];
}
-(void)messageBtnClick:(UIButton* )btn{
    DDLog(@"点击啦消息中心");
    
}
//初始化tableView
-(void)modifyTableView{
    //设置表尾
    if (self.dataArr.count >= 15) {
        //设置行高
        //self.tableView.rowHeight = 10 * 2 + 75 ;
//        UIButton* bottomBtn = [Factory createButtonWithTitle:@"点击加载全部任务" frame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titleFont:14 textColor:NavBarTintColor backgroundColor:BackGroundColor target:self selector:@selector(loadAllData:)];
//        self.tableView.tableFooterView = bottomBtn;
       // self.tableView.mj_footer.
    }
}
-(void)loadAllData:(UIButton* )btn{
    DDLog(@"加载全部任务数据");
    if ((_page + 1) * 15 > self.dataArr.count ) {
        [MBProgressHUD showFail:@"已经是最后一页啦！" view:self.view];
        [self.tableView.mj_footer endRefreshing];
        return ;
    }
    ++ _page;
    [self requestDataWithPage:_page isLoading:YES type:@""];
}
#pragma mark - 定位
-(void)creatTopLocationItem {
    self.locationBtn = [[YMLocationButton alloc]initWithFrame:CGRectMake(0, 0,  120, NavBarHeight)];
    self.locationBtn.titlLabel.text = @"上海市";
    [self.locationBtn addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.locationBtn];
    
}
-(void)locationAction:(UIButton* )btn{
    UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"是否需要定位到当前位置？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alerAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * alerAct2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //重新定位
        [_locService startUserLocationService];
        
    }];
    [alerC addAction:alerAct1];
    [alerC addAction:alerAct2];
    [self presentViewController:alerC animated:YES completion:nil];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        DDLog(@"pt == %f",pt.latitude);
        
        BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            DDLog(@"反geo检索发送成功");
        }
        else
        {
            DDLog(@"反geo检索发送失败");
        }
        // 停止定位
        [_locService stopUserLocationService];
    }
}
//定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error{
    DDLog(@"定位失败@！");
    if([YMTool isOnLocation]){
        UIAlertView* alerView = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"网络连接失败，请检查网络！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alerView.tag = 101;
        [alerView show];
    }else{
        UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您的定位服务没有打开，请在设置中开启" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alerAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * alerAct2 = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                // url地址可以打开
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alerC addAction:alerAct1];
        [alerC addAction:alerAct2];
        [self presentViewController:alerC animated:YES completion:nil];
    }
}
#pragma mark - 反地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        DDLog(@"result === %f  address == %@  detail == %@",result.location.latitude,result.address,result.addressDetail);
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }else{
        DDLog(@"errror === %u  searcher == %@",error,searcher);
    }
}

/**
 *根据地理坐标获取地址信息
 *异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetAddrResult通知
 *@param reverseGeoCodeOption 反geo检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)reverseGeoCode:(BMKReverseGeoCodeOption*)reverseGeoCodeOption{
    return YES;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 173 * kWidthRate;
    }
    else{
        return 10 * 2 + 75;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWeakSelf;
    if (indexPath.section == 0) {
        MainItemCell * cell = [[MainItemCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 173 * kWidthRate) itemTitleArr:self.titleArr imgsArr:self.imgsArr];
        cell.tapHandler = ^(MainItemButton* btn ){
            DDLog(@"点击啦按钮 btn tag == %ld",(long)btn.tag);
            [weakSelf handleMainItemsBtnClick:btn];
        };
        return cell;
    }else{
        YMTaskCell *cell = [YMTaskCell cellDequeueReusableCellWithTableView:tableView];
        cell.model       = self.dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //开始预加载
        if (indexPath.row == self.dataArr.count - 3) {
            [weakSelf.tableView.mj_footer beginRefreshing];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self requestTaskDetailByModel:_dataArr[indexPath.row]];
}
-(void)requestTaskDetailByModel:(YMTaskModel*)model{
    YMWeakSelf;
    [[HttpManger sharedInstance]getHTTPReqAPI:[NSString stringWithFormat:@"%@?id_task=%@",TaskDetailURL,model.id.stringValue] params:@{@"id_task":model.id.stringValue} view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        YMTaskDetailController* tvc = [[YMTaskDetailController alloc]init];
        tvc.title = @"任务详情";
        tvc.hidesBottomBarWhenPushed = YES;
        tvc.model = model;
        [weakSelf.navigationController pushViewController:tvc animated:YES];
    }];
}

//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 0.5 * SCREEN_WIDTH; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark -  处理 首页按钮响应方法  跳转到指定分类界面
-(void)handleMainItemsBtnClick:(MainItemButton* )btn{
    YMTaskViewController* yvc = [[YMTaskViewController  alloc]init];
    yvc.title = btn.titlLabel.text;
    yvc.type  = btn.tag;
    if (btn.tag == 26) {
        yvc.type = 0;
    }
    yvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yvc animated:YES];
}
#pragma mark - lazy
-(BMKLocationService *)locService{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return _locService;
}
-(BMKGeoCodeSearch *)geocodesearch{
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
       // _geocodesearch.delegate = self;
    }
    return _geocodesearch;
}
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"证券开户",@"朋友圈转发",@"金融理财",@"全部任务"];
    }
    return _titleArr;
}
-(NSArray *)imgsArr{
    if (!_imgsArr) {
        _imgsArr = @[@"negotiable",@"wechat",@"management",@"all"];
    }
    return _imgsArr;
}
@end
