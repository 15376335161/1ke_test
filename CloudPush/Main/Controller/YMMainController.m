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
#import "YMWebViewController.h"
#import "BaseWebViewController.h"
#import "YMRedBagController.h"
#import "BaseWebViewController.h"
#import "YMMsgListController.h"

#import "YMPartnerController.h"

@interface YMMainController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//新手推荐
@property(nonatomic,strong)NSMutableArray* hostProdtListArr;
//热门推荐
@property(nonatomic,strong)NSMutableArray* newsProductListArr;

//图片浏览器
@property(nonatomic,strong)NSMutableArray* imgsArr;


@property(nonatomic,copy)NSString* rewardTotal;//奖励累积
@property(nonatomic,copy)NSString* joinNums;   //参与人数

//消息中心
@property(nonatomic,strong)UIButton* messageBtn;
@property(nonatomic,strong)UILabel*  mesgNumLabel;
@end

@implementation YMMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    [self requestData];
    //修改view
    [self modifyTableView];
    //消息中心
    [self creatRightItem];
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
        //新品推荐
        weakSelf.newsProductListArr = [YMProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"newProductList"]];
        //热门推荐
        weakSelf.hostProdtListArr = [YMProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"hostProductList"]];
        weakSelf.joinNums = responseObject[@"data"][@"joinNums"];
        weakSelf.rewardTotal = responseObject[@"data"][@"rewardTotal"];
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
        NSString* imgPath =[NSString stringWithFormat:@"%@%@",BaseApi,model.banner_path];
        if ([imgPath isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:imgPath];
        } else if ([imgPath isKindOfClass:[NSURL class]]) {
            url = (NSURL *)imgPath;
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

    sdSycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    sdSycleView.placeholderImage = [UIImage imageNamed:@"bigPlaceholder"];
    self.tableView.tableHeaderView = sdSycleView;
}
#pragma mark - 修改view
-(void)modifyTableView{
    self.tableView.tableFooterView = [UIView new];
    YMWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}
#pragma mark - 消息中心
-(void)creatRightItem{
    self.messageBtn = [Factory createNavBarButtonWithImageStr:@"news" target:self selector:@selector(messageBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_messageBtn];
    
//    _mesgNumLabel = [Factory createCircleLabelWithFrame:CGRectMake(CGRectGetWidth(_messageBtn.frame) - 5 , -5, 14, 14) text:@"9" textColor:WhiteColor fontSize:10 bgColor:RedColor borderColor:RedColor borderWidth:1];
//    [_messageBtn addSubview:_mesgNumLabel];
}
-(void)messageBtnClick:(UIButton* )btn{
    if ([[YMUserManager shareInstance]isValidLogin]) {
        YMMsgListController* mvc = [[YMMsgListController alloc]init];
        mvc.title = @"消息中心";
        mvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mvc animated:YES];
    }else{
        
        [[YMUserManager shareInstance]pushToLoginWithViewController:self];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int i = 1;
    if (self.newsProductListArr.count > 0) {
        i ++;
    }
    if (self.hostProdtListArr.count > 0) {
        i ++;
    }
    return i;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            //优先新品
            if (self.newsProductListArr.count > 0) {
                return self.newsProductListArr.count;
            }else{
                return self.hostProdtListArr.count;
            }
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
    YMWeakSelf;
    YMProductCell* prodctCell = [YMProductCell shareCellWithTableView:tableView actionBlock:^(UIButton *btn) {
        DDLog(@"btn tag == %ld",(long)btn.tag);
       // if ([[YMUserManager shareInstance]isValidLogin]) {
            BaseWebViewController* wvc = [[BaseWebViewController alloc]init];
            YMProductCell* prodctCell = [tableView cellForRowAtIndexPath:indexPath];
            YMProductModel* model = prodctCell.model;
            wvc.title  = @"项目详情";
            wvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&platform_id=%@&ssotoken=%@",ProductDetailURL,[kUserDefaults valueForKey:kUid] ? [kUserDefaults valueForKey:kUid] : @"",model.id,[kUserDefaults valueForKey:kToken] ? [kUserDefaults valueForKey:kToken] : @"" ];
            wvc.platform_id = model.id;
            DDLog(@"urlStr == %@",wvc.urlStr);
            wvc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:wvc animated:YES];
//        }else{
//            [[YMUserManager shareInstance]pushToLoginWithViewController:self];
//        }
    }];
    prodctCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            YMMainHeadCell* cell = [YMMainHeadCell  shareCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.tapBlock = ^(UIButton* btn){
                DDLog(@"btn tag == %ld",(long)((UIButton*)btn).tag);
                switch (btn.tag) {
                    case 0:
                    {
                        DDLog(@"签到领一元");
                        YMRedBagController* wvc = [[YMRedBagController alloc]init];
                        wvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",UserSignListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]] ;
                        wvc.title = @"签到领一元";
                        wvc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:wvc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //跳转到 合伙人
                        self.tabBarController.selectedIndex = 1;
                    }
                        break;
                    case 2:
                    {
                        //红包列表
                        if ([[YMUserManager shareInstance]isValidLogin]) {
                            YMRedBagController* rvc = [[YMRedBagController alloc]init];
                            rvc.title = @"我的红包";
                            rvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",RedPaperListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]] ;
                            rvc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:rvc animated:YES];
                        }else{
                           [[YMUserManager shareInstance]pushToLoginWithViewController:self];
                        }
                    }
                        break;
                    default:
                        break;
                }
                
            };
            cell.partNumLabel.text = [NSString stringWithFormat:@"累积参与%@人",self.joinNums.intValue ? self.joinNums : @"0"];
            cell.partMoneyLabel.text = [NSString stringWithFormat:@"累积奖励%@元",self.rewardTotal.floatValue ? self.rewardTotal : @"0"];
            return cell;
        }
            break;
         case 1:
        {
            if (self.newsProductListArr.count > 0) {//新手推荐
                 prodctCell.model = self.newsProductListArr[indexPath.row];
                if (indexPath.row == self.newsProductListArr.count - 1) {
                    prodctCell.height += 10;
                }
            }else{
                 // 热门推荐
                 prodctCell.model = self.hostProdtListArr[indexPath.row];
                if (indexPath.row == self.hostProdtListArr.count - 1) {
                    prodctCell.height += 10;
                }
            }
            
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
    YMHeadFootView* headfootView = [YMHeadFootView cellDequeueReusableCellWithTableView:tableView];
    switch (section) {
        case 1:
            if (self.newsProductListArr.count > 0) {
                headfootView.titlLabel.text = @"新手推荐";
                return headfootView;
            }else{
                if (self.hostProdtListArr.count > 0) {
                    headfootView.titlLabel.text = @"热门推荐";
                    return headfootView;
                }else{
                    return nil;
                }
            }
            break;
        case 2:
            if (self.hostProdtListArr.count > 0) {
                headfootView.titlLabel.text = @"热门推荐";
                return headfootView;
            }else{
                return nil;
            }
            break;
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ( section == 1 ){
    
        return 27;
    }
    if (section == 2) {
        return 27;
    }
    else{
        return 0;
    }
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 108;
            break;
        case 1:
            //优先新品
//            if (self.newsProductListArr.count > 0) {
//                //最后一个
//                if (indexPath.row == self.newsProductListArr.count - 1) {
////                    YMProductCell* prodctCell = [tableView cellForRowAtIndexPath:indexPath];
////                    prodctCell.height += 10;
//                    return 235;
//                }else{
//                   return 235 + 10;
//                }
//            }else{
//                //最后一个
//                if (indexPath.row == self.newsProductListArr.count - 1) {
//                    return 235;
//                }else{
//                    return 235 + 10;
//                }
//            }
            return 235 + 10;
            break;
        case 2:
            return 235 + 10;//235
            break;
        default:
            return 0;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"点击啦 row == %ld colum == %ld",(long)indexPath.row,(long)indexPath.section);
    if (indexPath.section > 0) {
       // if ([[YMUserManager shareInstance]isValidLogin]) {
            BaseWebViewController * wvc = [[BaseWebViewController alloc]init];
            YMProductCell* prodctCell = [tableView cellForRowAtIndexPath:indexPath];
            YMProductModel* model = prodctCell.model;
            wvc.title  = @"项目详情";
            wvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&platform_id=%@&ssotoken=%@",ProductDetailURL,[kUserDefaults valueForKey:kUid] ? [kUserDefaults valueForKey:kUid] : @"",model.id,[kUserDefaults valueForKey:kToken] ? [kUserDefaults valueForKey:kToken] : @"" ];
            wvc.platform_id = model.id;
            DDLog(@"urlStr == %@",wvc.urlStr);
       
            wvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wvc animated:YES];
//        }else{
//            [[YMUserManager shareInstance]pushToLoginWithViewController:self];
//        }
    }
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
