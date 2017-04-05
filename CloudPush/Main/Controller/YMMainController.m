//
//  YMMainController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.

#import "YMMainController.h"
#import "YMItemCell.h" // 金融理财。贷款
#import "YMProductCell.h"
#import "SDCycleScrollView.h"
#import "YMHeadItemCell.h"

#import "YMMainHeadCell.h"
#import "YMSectionCell.h"

#import "YMProductModel.h"
#import "YMBannerModel.h"

#import "YMHeadFootView.h"


@interface YMMainController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//新手推荐
@property(nonatomic,strong)NSMutableArray* hostProdtListArr;
//热门推荐
@property(nonatomic,strong)NSMutableArray* newsProductListArr;

//图片浏览器
@property(nonatomic,strong)NSMutableArray* imgsArr;
@end

@implementation YMMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    //请求数据
    [self requestData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 请求网络数据
-(void)requestData{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    [param setObject:@(interval).stringValue forKey:@"time"];
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:HomeDataURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        //轮播图
        weakSelf.imgsArr = [YMBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"bannerList"]];
        if (weakSelf.imgsArr.count > 0) {
            [weakSelf creatcycleScrollView];
        }
        //热门推荐
        weakSelf.hostProdtListArr = [YMProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"hostProductList"]];
        //新品推荐
        weakSelf.newsProductListArr = [YMProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"newProductList"]];
        //刷新数据
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - 创建滚动试图
-(void)creatcycleScrollView{
    NSMutableArray* imgsArr = [[NSMutableArray alloc]init];
    [self.imgsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url;
        YMBannerModel* model =(YMBannerModel*)obj;
        if ([model.banner_path isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:model.banner_path];
        } else if ([model.banner_path isKindOfClass:[NSURL class]]) {
            url = (NSURL *)model.banner_path;
        }
        if (url) {
            [imgsArr addObject:url];
        }
    }];

    SDCycleScrollView* sdSycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9/25)imageURLStringsGroup:imgsArr];
    sdSycleView.delegate = self;
    sdSycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    sdSycleView.currentPageDotColor = WhiteColor;
    sdSycleView.pageDotColor        = LightGrayColor;
    
    // sdSycleView.
    sdSycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    sdSycleView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    self.tableView.tableHeaderView = sdSycleView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.newsProductListArr.count;
            break;
        case 2:
            return self.hostProdtListArr.count;
            break;
        default:
            break;
    }
    return 1;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMProductCell* prodctCell = [YMProductCell shareCellWithTableView:tableView actionBlock:^(UIButton *btn) {
        DDLog(@"btn tag == %ld",(long)btn.tag);
    }];
    prodctCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            YMMainHeadCell* cell = [YMMainHeadCell  shareCell];
          //  YMHeadItemCell* cell = [[YMHeadItemCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) itemsTitlArr:@[@"签到领一元",@"邀请赚钱",@"红包赚钱"] imgsArr:@[@"cont_Sign in",@"cont_invitation",@"cont_reward"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tapBlock = ^(UIButton* btn){
                DDLog(@"btn tag == %ld",(long)((UIButton*)btn).tag);
            };
            return cell;
        }
            break;
         case 1:
        {
            prodctCell.model = self.newsProductListArr[indexPath.row];
            return prodctCell;
        }
            break;
        case 2:
        {
            prodctCell.model = self.hostProdtListArr[indexPath.row];
            return prodctCell;
        }
            break;
        default:
            break;
    }
    return nil;
}
-(UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   // YMSectionCell* cell = [YMSectionCell cellDequeueReusableCellWithTableView:tableView];
    YMHeadFootView* headfootView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YMHeadFootView"];
    if (headfootView == nil) {
        headfootView = [[YMHeadFootView alloc]initWithReuseIdentifier:@"YMHeadFootView"];
    }
    switch (section) {
        case 1:
            headfootView.titlLabel.text = @"新手推荐";
            break;
        case 2:
            headfootView.titlLabel.text = @"热门推荐";
            break;
        default:
            break;
    }
    return headfootView;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 103;
            break;
        case 1:
            return 235;
            break;
        case 2:
            return 235;//235
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;
         case 1:
            return 27;
            break;
        case 2:
            return 27;
            break;
        default:
            return 0;
            break;
    }
}

//-(UIView* )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//       // YMItemCell* cell = [[YMItemCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4 ) itemsArr:@[@"financial",@"loan"] SpaceX:10 marginX:5 spaceY:15 marginY:5 superView:self.view];
//        YMItemCell* cell = [YMItemCell shareCell];
//        cell.tapBlock = ^(UITapGestureRecognizer *tap) {
//            DDLog(@"点击啦tap == %ld",tap.view.tag);
//        };
//        return cell;
//    }
//    return nil;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        return (SCREEN_WIDTH - 10 * 2 - 5)/2 * 14/35 + 15 * 2 + 10;
//    }else{
//        return 0;
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"点击啦 row == %ld colum == %ld",(long)indexPath.row,(long)indexPath.section);
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
     DDLog(@"图片轮播点击了 %ld",(long)index);
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
   // DDLog(@"图片轮播滚动了 %ld",(long)index);
}

#pragma mark - scrollViewDelegate
//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView){
//         UITableView *tableview = (UITableView *)scrollView;
//         CGFloat sectionHeaderHeight = 27;
//         CGFloat sectionFooterHeight = (SCREEN_WIDTH - 10 * 2 - 5)/2 * 14/35 + 15 * 2 + 10;
//         CGFloat offsetY = tableview.contentOffset.y;
//         if (offsetY >= 0 && offsetY <= sectionHeaderHeight){
//        
//              tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
//             
//         }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight){
//             
//              tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
//             
//        }else if(offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height){
//            
//             tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
//        }
    }
}


@end
