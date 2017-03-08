//
//  YMWelcomeController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWelcomeController.h"
#import "YMTabBarController.h"

@interface YMWelcomeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UICollectionView* collectView;
@property(nonatomic,strong)NSArray* imgsArr;

//分页控件
@property(nonatomic,strong)UIPageControl* pageControl;
@end

@implementation YMWelcomeController

NSString *const kCellIdentify = @"UICollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建collectView
    [self creatCollectView];
    
    //设置分页 控件
    [self setUpPageControl];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 分页器
- (void)setUpPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2 / 5, SCREEN_HEGIHT * 9 / 10, SCREEN_WIDTH / 5, 10)];
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
}
-(void)creatCollectView {
    //UICollectionView的布局 都要依赖于 layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //所有的cell 的大小 屏幕大小
    layout.itemSize = kScreenSize;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    //创建
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT) collectionViewLayout:layout];
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    self.collectView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectView];
    //注册 cell 需要注册
    [self.collectView registerClass:[UICollectionViewCell  class] forCellWithReuseIdentifier:kCellIdentify];
    //分页滚动
    self.collectView.pagingEnabled = YES;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgsArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify forIndexPath:indexPath];
    //设置背景 --- 不会缓存 占内存少
    NSString *path = [[NSBundle mainBundle] pathForResource:self.imgsArr[indexPath.row] ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    
    //都会缓存
    // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgsArr[indexPath.row]]];
  
    //背景图片最后一个 添加注册  和 登陆 按钮
    if (indexPath.row == self.imgsArr.count - 1) {
        _pageControl.hidden = YES;
        [self cell:cell modifyViewWithIndexPath:indexPath];
    }
    return cell;
}

-(void)cell:(UICollectionViewCell *)cell modifyViewWithIndexPath:(NSIndexPath* )indexpath
{
    UIButton * loginBtn = [[UIButton alloc]init];
    [cell addSubview:loginBtn];
    
    loginBtn.sd_layout.leftSpaceToView(cell,10).rightSpaceToView(cell,10).bottomSpaceToView(cell,10).heightIs(40);
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = RedColor;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)loginBtnClick:(UIButton* )btn{
    DDLog(@"点击了登陆");
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //最后一页点击跳转
    if (indexPath.row == self.imgsArr.count-1) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        YMTabBarController* rvc = [[YMTabBarController alloc]init];
        window.rootViewController = rvc;
    }
}
/**
 *  scrolView代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.pageControl.currentPage = (int)(self.collectView.contentOffset.x / self.collectView.width + 0.5);
    if ( self.pageControl.currentPage == 2) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
}
#pragma mark - lazy
-(NSArray *)imgsArr{
    if (!_imgsArr) {
        _imgsArr = @[@"wel1",@"wel1",@"wel1"];
    }
    return _imgsArr;
}
@end
