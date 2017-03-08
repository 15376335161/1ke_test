//
//  YMTaskBaseController.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskBaseController.h"
#import "MyTasksViewController.h"

@interface YMTaskBaseController ()<UIScrollViewDelegate>

//标签底部蓝色指示器
@property(nonatomic,weak)UIView *indicatorView;
//当前选中的按钮
@property(nonatomic,weak)UIButton *selectedBtn;
//标签容器
@property(nonatomic,weak)UIScrollView *tagScrollView;
//子控制器view容器
@property(nonatomic,weak)UIScrollView *conScrollView;
//所有的按钮
@property(nonatomic,strong)NSMutableArray* allBtnsArr;
@end

@implementation YMTaskBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认第一个
    self.flag = 0;
    //设置导航拦
    [self setUpNavi];
    // 设置子控制器
    [self setUpChildVcs];
    //设置 标题
    [self setUpTitlesView];
    // 设置滚动视图
    [self setUpScrollView];
}
- (void)viewDidAppear:(BOOL)animated{
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self titleClick:self.allBtnsArr[self.flag]];
}

- (void)setUpNavi{
    
    //防止tableView偏离导航栏64个点
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    //导航栏
    self.title = @"我的任务";
    self.view.backgroundColor = WhiteColor;
}
- (void)setUpChildVcs{
    for (int i = 0 ; i < 4; i ++) {
        MyTasksViewController  *mvc = [[MyTasksViewController alloc] init];
        //mvc.title = @"全部订单";
        mvc.tag = i ;
        [self addChildViewController:mvc];
    }
}
/**
 *  设置顶部标签栏
 */
- (void)setUpTitlesView{
    
    //标签栏整体
    UIScrollView *tagScrollView = [[UIScrollView alloc] init];
    tagScrollView.width  = SCREEN_WIDTH;
    tagScrollView.height = TitleViewHeigh;
    tagScrollView.y = 1;
    tagScrollView.contentSize = CGSizeMake((SCREEN_WIDTH / 4) * self.childViewControllers.count, TitleViewHeigh);
    tagScrollView.showsHorizontalScrollIndicator = NO;
    tagScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tagScrollView];
    self.tagScrollView = tagScrollView;
    
    //添加分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TitleViewHeigh, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BackGroundColor;
    [self.view addSubview:lineView];
    
    //底部指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = NavBarTintColor;
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = tagScrollView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    //内部子标签
    CGFloat width = SCREEN_WIDTH / 4;
    //    DDLog(@"btn width ===== %.2f",width);
    CGFloat height = tagScrollView.height;
    NSArray* tagsArr = @[@"待处理",@"审核中",@"审核完成",@"已失效"];
    for (int i = 0; i < tagsArr.count; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.height = height;
        btn.width = SCREEN_WIDTH / 4;
        btn.x = i * width;
    
        //   DDLog(@"控制器标题 ======= %@\n",vc.title);
        [btn setTitle:tagsArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:NavBarTintColor forState:UIControlStateNormal];
        //选中状态
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagScrollView addSubview:btn];
        
        [self.allBtnsArr addObject:btn];
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            //根据button内部的文字宽度计算尺寸
            self.indicatorView.width   = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
        }
    }
    //  DDLog(@"数组 ======== %@\n",self.btnArr);
    [tagScrollView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button{
   // DDLog(@"btn arr == %@  buttn status == %d",self.allBtnsArr,button.selected);
    for (UIButton* btn in self.allBtnsArr) {
       btn.selected = YES;
    }
    button.selected = NO;
    DDLog(@"btn status == %d",button.selected);
   // [button setTitleColor:NavBarTintColor forState:UIControlStateSelected];
    //动态改变flag.方便详情,支付页面的跳转
    self.flag = button.tag;
    
    //标签栏scrollView的滚动
    CGPoint offset_tag = self.tagScrollView.contentOffset;
    if (button.tag == 4) {
        offset_tag.x = (SCREEN_WIDTH / 4) * button.tag;
        [self.tagScrollView setContentOffset:offset_tag];
    }else if (button.tag < 4){
        offset_tag.x = 0;
        [self.tagScrollView setContentOffset:offset_tag];
    }
    
    //修改
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
   // self.selectedBtn.selected = YES;
    DDLog(@"buttom frame ===== %.2f\n",button.frame.origin.x);
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    //滚动
    CGPoint offset = self.conScrollView.contentOffset;
    offset.x = button.tag * self.conScrollView.width;
    [self.conScrollView setContentOffset:offset animated:YES];
    
    [self scrollViewDidEndScrollingAnimation:self.conScrollView];
}

/**
 *  底部的scrollView
 */
- (void)setUpScrollView{
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    CGFloat y = CGRectGetMaxY(self.tagScrollView.frame) ;// + 10
    contentView.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEGIHT - y - 64 - TabBarHeigh );
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.conScrollView = contentView;
    
    // 添加第一个控制器的view
    // [self scrollViewDidEndScrollingAnimation:contentView];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    vc.view.width = scrollView.width;
    vc.view.autoresizingMask = UIViewAutoresizingNone;//禁止子控件随着父控件的变化而变化
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    //    CGPoint offset = self.tagScrollView.contentOffset;
    //    if (index == 4) {
    //        offset.x = (SCREEN_WIDTH / 4) * index;
    //        [self.tagScrollView setContentOffset:offset];
    //    }else if (index < 4){
    //        offset.x = 0;
    //        [self.tagScrollView setContentOffset:offset];
    //    }
    [self titleClick:self.tagScrollView.subviews[index]];
}


//所有的按钮
-(NSMutableArray *)allBtnsArr{
    if (!_allBtnsArr) {
        _allBtnsArr = [[NSMutableArray alloc]init];
    }
    return _allBtnsArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
