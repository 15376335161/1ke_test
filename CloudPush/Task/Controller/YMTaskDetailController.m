//
//  YMTaskDetailController.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskDetailController.h"
#import "StepView.h"
#import "YMTaskHeadCell.h"
#import "YMBottomView.h"
#import "YMBusinessView.h"
#import "YMMapView.h"
#import "YMContentView.h"
#import "YMTaskInfoController.h"
#import "YMTitleView.h"
#import "YMReceSuccessController.h"
#import "YMTaskStatusModel.h"
#import "YMUserManager.h"

@interface YMTaskDetailController ()<UIScrollViewDelegate>

//标题数组
@property(nonatomic,strong)NSArray* titlesArr;
@property(nonatomic,strong)UIScrollView* conScrollView;
//介绍 技巧等
@property(nonatomic,strong)YMTitleView* titleView;

@end

@implementation YMTaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGroundColor;
    
    //设置滚动视图
    UIScrollView* scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    scrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomSpaceToView(self.view,40);
    
    UIView* contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    
    contentView.sd_layout.leftEqualToView(scrollView).topEqualToView(scrollView).rightEqualToView(scrollView).heightIs(700);
    contentView.backgroundColor = BackGroundColor;
    scrollView.contentSize = contentView.size;
    
    //头部
    YMTaskHeadCell*  cell = [YMTaskHeadCell shareCell];
    cell.model = self.model;
    [contentView addSubview:cell];
    //业务概要
    YMBusinessView * bussView = [[YMBusinessView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.frame) + 7, SCREEN_WIDTH, 100) title:@"业务概况：" content:self.model.outline];
    [contentView addSubview:bussView];
    
    //地图
    YMMapView* mapView = [[YMMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bussView.frame), SCREEN_WIDTH, 100) title:@"推广地图：" content:@""];
    [contentView addSubview:mapView];
    
    //设置文案内容
     YMWeakSelf;
    YMContentView* descView = [[YMContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mapView.frame) + 7, SCREEN_WIDTH, 100) title:@"文案内容：" content:self.model.short_des imgsArr:@[@"http://pic11.nipic.com/20101214/213291_155243023914_2.jpg",@"http://pic.58pic.com/58pic/13/71/40/95P58PICtdF_1024.jpg",@"http://pic.58pic.com/58pic/14/27/45/71r58PICmDM_1024.jpg",@"http://pic.58pic.com/58pic/14/27/56/97H58PICjsU_1024.jpg"] detailBlocK:^(){
        
        DDLog(@"详情按钮执行啦");
        YMReceSuccessController* mvc = [[YMReceSuccessController alloc]init];
        mvc.title = @"接单成功";
        [weakSelf.navigationController pushViewController:mvc animated:YES];
        
    }];
     [contentView addSubview:descView];
    
    //设置推广技巧 任务流程 审核标准等
    
    self.titleView = [[YMTitleView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(descView.frame) + 7, SCREEN_WIDTH, 40) titlesArr:self.titlesArr selectColor:NavBarTintColor normalColor:HEX(@"333333") clickBtnBlock:^(UIButton *btn) {
        DDLog(@"按钮点击啦 btn tag == %@",btn );
        //滚动
        CGPoint offset = weakSelf.conScrollView.contentOffset;
        offset.x = btn.tag * weakSelf.conScrollView.width;
        [weakSelf.conScrollView setContentOffset:offset animated:YES];
        
        [weakSelf scrollViewDidEndScrollingAnimation:self.conScrollView];
    }];
    
    [contentView addSubview:_titleView];
    
    //添加滚动内容视图
    [self conScrollViewWithTitleView:_titleView contentView:contentView];
   
    //设置子控制器
    [self setChildViewControllers];
   
    // 底部View
    YMBottomView* botmView = [[YMBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEGIHT - 40 - NavBarTotalHeight, SCREEN_WIDTH, 40)  titlesArr:@[@"立即接单"] backGgColorsArr:@[@"ACC9EB"] taskBlock:^(UIButton *btn) {
        DDLog(@"btn.tag == %ld  立即接单",(long)btn.tag);
        [weakSelf receiveOrderByModel:self.model];
    }];
    [self.view addSubview:botmView];

    //重新修改设置高度
    contentView.sd_layout.heightIs(CGRectGetMaxY(self.conScrollView.frame));
    scrollView.contentSize = CGSizeMake(contentView.width, contentView.height);
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //默认执行一次
    [self.titleView titleClick:_titleView.tagScrollView.subviews[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 立即接单
-(void)receiveOrderByModel:(YMTaskModel* )model{
    //立即接单 431
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    if (![kYMUserInstance isValidLogin]) {
        //登陆
        [kYMUserInstance pushToLoginWithViewController:self];
        return;
    }
    //用户id
   // NSString* usrId = [kUserDefaults valueForKey:kUid];
    [param setObject:@"1422" forKey:@"user_id"];
    [param setObject:model.id forKey:@"task_id"];
    [[HttpManger sharedInstance]callHTTPReqAPI:TaskReciveURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        DDLog(@" count == %@   res = %@",responseObject[@"data"][@"myTaskCounts"][@"COUNT(id)"],responseObject[@"data"]);
        
        YMTaskStatusModel* statusModel = [YMTaskStatusModel mj_objectWithKeyValues:responseObject[@"data"]];
        // [YMTaskStatusModel mj_objectWithKeyValues:<#(id)#>]
        DDLog(@"model === %@ stu",statusModel);
        DDLog(@"model == %@  taskCOunt == %@  mytaskList == %@  status == %@",statusModel,statusModel.myTaskCounts,statusModel.myTaskList,statusModel.myTaskStatus);
        
        YMReceSuccessController* rvc = [[YMReceSuccessController alloc]init];
        rvc.title = @"接单成功";
        rvc.model = statusModel;
        rvc.dicData = responseObject[@"data"];
        
        [self.navigationController pushViewController:rvc animated:YES];
    }];
}
-(void )conScrollViewWithTitleView:(UIView* )titleView contentView:(UIView* )contentView{
    if (!_conScrollView) {
        _conScrollView = [[UIScrollView alloc] init];
        _conScrollView.autoresizingMask = UIViewAutoresizingNone;
        CGFloat y = CGRectGetMaxY(titleView.frame) ;// + 10
        _conScrollView.frame = CGRectMake(0, y, SCREEN_WIDTH, 200 );//SCREEN_HEGIHT - 64 - TabBarHeigh
        _conScrollView.showsHorizontalScrollIndicator = NO;
        _conScrollView.showsVerticalScrollIndicator = NO;
        _conScrollView.delegate = self;
        _conScrollView.pagingEnabled = YES;
        [contentView addSubview:_conScrollView ];
        _conScrollView.contentSize = CGSizeMake(_conScrollView.width * self.titlesArr.count, 200);
    }

}
-(void)setChildViewControllers{
    for (int i = 0 ; i < self.titlesArr.count; i ++) {
        YMTaskInfoController* mvc = [[YMTaskInfoController alloc]init];
        mvc.tag = i;
        mvc.info = [NSString stringWithFormat:@"info  %d",i];
        mvc.view.backgroundColor = WhiteColor;
        [self addChildViewController:mvc];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    // 取出子控制器
    YMTaskInfoController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    vc.view.width = scrollView.width;
    vc.info = [NSString stringWithFormat: @"info === %ld",(long)index];
    vc.view.autoresizingMask = UIViewAutoresizingNone;//禁止子控件随着父控件的变化而变化
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    DDLog(@"index == %ld",(long)index);
    //滚动
    CGPoint offset = self.conScrollView.contentOffset;
    offset.x = index * self.conScrollView.width;
    [self.conScrollView setContentOffset:offset animated:YES];
    
    [self.titleView titleClick:self.titleView.tagScrollView.subviews[index]];
}

#pragma mark - lazy
-(NSArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = @[@"任务流程",@"审核标准"];//,@"推广技巧"
    }
    return _titlesArr;
}

@end
