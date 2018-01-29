//
//  YMMeViewController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.

#import "YMMeViewController.h"
#import "YMMeIconCell.h"
#import "YMTitleCell.h"
#import "UIImage+Extension.h"
#import "YMMeWalletCell.h" //钱包
#import "YMWalletController.h"
#import "YZTShareController.h"
#import "YMMsgListController.h"
#import "YMFeedBackController.h"
#import "YMSetController.h"
#import "UserModel.h"
#import "HWImagePickerSheet.h"
#import "RSAEncryptor.h"
#import "YMRedBagController.h"
#import "YMTaskBaseController.h"
#import "YMPartnerController.h"
#import "YMRegistWebController.h"
#import "SDAutoLayout.h"


@interface YMMeViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
     UIImageView *navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//去掉导航
@property(nonatomic,strong)UIImageView* barImageView;

@property(nonatomic,strong)NSArray* titileArr;
@property(nonatomic,strong)NSArray* iconArr;

//选择图片
@property(nonatomic,strong)UIImagePickerController* imgPickController;

//选择的照片
@property(nonatomic,strong)NSMutableArray* arrSelected;

@property(nonatomic,strong)UserModel* usrModel;

//头部的头像
@property(nonatomic,strong)YMMeIconCell* headIconCell;

//显示框
@property(nonatomic,strong)MBProgressHUD* HUD;

@end

@implementation YMMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    //调整 设置 修改 view
    [self modifyView];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_barImageView ) {
        _barImageView = self.navigationController.navigationBar.subviews.firstObject;
        _barImageView.alpha = 0;
    }
     //再定义一个imageview来等同于这个黑线
     navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
     navBarHairlineImageView.hidden = YES;
    //初始化登录
    if ([[YMUserManager shareInstance] isValidLogin]) {
        //请求用户数据
        [self requestUserDataWithIsPush:NO];
    }else{
        //登录
         YMLoginController* lvc = [[YMLoginController alloc]init];
         lvc.isToTabBar = YES;
         //lvc.hidesBottomBarWhenPushed = YES;
         YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
         [self presentViewController:nav animated:NO completion:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    //恢复之前的导航色
    _barImageView.alpha = 1;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
-(void)dealloc{
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_UserDataChanged object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_LoginOut object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - modifyView
-(void)modifyView{
    //处理导航 透明问题
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = NavBarTintColor;
    
    //处理导航 透明问题
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    _barImageView.alpha = 0;
    
    //设置背景
    UIView* topBgView = [[UIView alloc]init];
    topBgView.backgroundColor = DefaultNavBarColor;
    [self.view insertSubview:topBgView atIndex:1];
    topBgView.sd_layout.topSpaceToView(self.view, -64).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(self.view.height/2);
    
    //调整tabBar 背景
    self.tableView.sd_layout.bottomSpaceToView(self.view, 48);
    [self.view bringSubviewToFront:self.tableView];
    //    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //    UIVisualEffectView *vew = [[UIVisualEffectView alloc]initWithEffect:blur];
    self.tabBarController.tabBar.backgroundColor = WhiteColor;
    self.view.backgroundColor = BackGroundColor;

    self.tableView.scrollEnabled = YES;

    YMWeakSelf;
    _headIconCell = [[[NSBundle mainBundle]loadNibNamed:@"YMMeIconCell" owner:nil options:nil] lastObject];
    _headIconCell.changeIconBlock = ^{
        DDLog(@"用户头像点击啦");
        if ([[YMUserManager shareInstance] isValidLogin]) {
             [weakSelf showActionSheet];
        }else{
            [[YMUserManager shareInstance] pushToLoginWithViewController:weakSelf];
        }
    };
    _headIconCell.usrModel = self.usrModel;
    self.tableView.tableHeaderView = _headIconCell;
    //右键
    UIButton* rightBarBtn = [Factory createNavBarButtonWithImageStr:@"my_set up" target:self selector:@selector(setBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
}
-(void)userLoginOut:(NSNotification* )notification{
    DDLog(@"用户推出登录");
    _usrModel = nil;
    _headIconCell.usrModel = _usrModel;
    [_tableView reloadData];
    
    self.tabBarController.selectedIndex = 0;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 5;
    }
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMTitleCell* cell = [YMTitleCell cellDequeueReusableCellWithTableView:tableView];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
              [cell cellWithTitle:self.titileArr[indexPath.row] icon:self.iconArr[indexPath.row]];
        }else{
            YMMeWalletCell* shareCell = [[[NSBundle mainBundle]loadNibNamed:@"YMMeWalletCell" owner:self options:nil]lastObject];
            shareCell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 用户模型
            shareCell.usrModel = self.usrModel;
            shareCell.tapViewBlock = ^(UITapGestureRecognizer *tap) {
                DDLog(@"点击啦tap tag == %d",tap.view.tag);
            };
            return shareCell;
        }
    }
    if (indexPath.section == 1) {
         [cell cellWithTitle:self.titileArr[indexPath.row + 1] icon:self.iconArr[indexPath.row + 1]];
        if (indexPath.row == 2 && self.usrModel.countMessage.integerValue > 0) {
            UIView* newView = [[UIView alloc]init];
            //  WithFrame: CGRectMake(CGRectGetMaxX(newRect),CGRectGetMinY(newRect),4, 4)];
            newView.layer.cornerRadius = 2;
            newView.backgroundColor = RedColor;
            newView.clipsToBounds = YES;
            [cell.titlLabel addSubview:newView];
            newView.sd_layout.rightSpaceToView(cell.titlLabel,-3 ).topSpaceToView(cell.titlLabel,-3).widthIs(4).heightIs(4);
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 73;
    } else {
        return 46;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 0;
    }
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"点击啦 某一行");
    if ([[YMUserManager shareInstance] isValidLogin]) {
        switch (indexPath.section) {
            case 0:
            {
                YMWalletController* pvc = [[YMWalletController alloc]init];
                pvc.title = @"钱包";
                pvc.usrModel = self.usrModel;
                pvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pvc animated:YES];
            }
                break;
            case 1:
            {
                if(indexPath.row == 0){
                    YMTaskBaseController* tvc = [[YMTaskBaseController alloc]init];
                    tvc.title = @"参与记录";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }
                else if(indexPath.row == 1){
                  
                    YMRedBagController* tvc = [[YMRedBagController alloc]init];
                    tvc.title = @"我的红包";
                    tvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",RedPaperListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
                    tvc.backBlock = ^(){
                        DDLog(@"返回了");
                    };
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }
                else if (indexPath.row == 2) {
                    YMMsgListController* pvc = [[YMMsgListController alloc]init];
                    pvc.title = @"消息中心";
                    pvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:pvc animated:YES];
                }else if (indexPath.row == 3){
                    YMFeedBackController* tvc = [[YMFeedBackController alloc]init];
                    tvc.title = @"意见反馈";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }else{
                    YMRegistWebController* svc = [[YMRegistWebController alloc]init];
                    svc.title = @"关于我们";
                    svc.urlStr = AboutUsURL;
                    svc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:svc animated:YES];
                }
            }
                break;
            default:
                break;
        }
    //未登录跳转到登录
    }else{
        [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//#pragma mark - 监听数据改变
//-(void)userDataChanged:(NSNotification* )notification{
//    DDLog(@" me == notification == %@",notification.userInfo);
//    [self requestUserDataWithIsPush:NO];
//}

-(void)requestUserDataWithIsPush:(BOOL)isPush{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"]; //                               //[kUserDefaults valueForKey:kUid]
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];//@"4a70ef79952fbb9cd62eefd0edc139a6"
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
         weakSelf.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        //存储用户信息
        [[YMUserManager shareInstance] saveUserInfoByUsrModel:weakSelf.usrModel];
        _headIconCell.usrModel = self.usrModel;
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - 上传头像
-(void)showActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imgPickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickController.delegate = self;
            //设置导航栏按钮文字的颜色
            [[UINavigationBar appearance]setTintColor:WhiteColor];
            [self presentViewController:_imgPickController animated:YES completion:^{
                //设置导航栏按钮文字的颜色
               // [[UINavigationBar appearance]setTintColor:WhiteColor];
            }];
        }
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imgPickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;;
            _imgPickController.delegate = self;
            //设置导航栏按钮文字的颜色
            [[UINavigationBar appearance]setTintColor:WhiteColor];
            [self presentViewController:_imgPickController animated:YES completion:^{
                //设置导航栏按钮文字的颜色
                //[[UINavigationBar appearance]setTintColor:WhiteColor];
            }];
        }
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (theImage) {
        //处理图片
        UIImage* newImage = [UIImage compressOriginalImage:theImage toSize:[UIImage comressSizeByImage:theImage]];
        [self updateUserIconWithImage:newImage];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//上传用户icon
-(void)updateUserIconWithImage:(UIImage* )image{
    YMWeakSelf;
    NSMutableDictionary* param = [NSMutableDictionary dictionary];

    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"]; //
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    //加载中
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        [[HttpManger sharedInstance]postFileHTTPReqAPI:uploadUserPicURL params:param imgsArr:@[image] view:self.view loading:NO completionHandler:^(id task, id responseObject, NSError *error) {
            [weakSelf requestUserDataWithIsPush:NO];
        }];
    }];
}
#pragma mark -  按钮响应方法
-(void)setBtnClick:(UIButton* )btn{
    DDLog(@"设置按钮点击啦");
    YMWeakSelf;
    YMSetController* svc = [[YMSetController alloc]init];
    svc.title = @"设置";
    svc.hidesBottomBarWhenPushed = YES;
    svc.backToMainBlock = ^{
        //返回首页
        weakSelf.tabBarController.selectedIndex = 0;
    };
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark - lazy
-(NSArray *)titileArr{
    if (!_titileArr) {
        _titileArr = @[@"我的钱包",@"参与记录",@"我的红包",@"消息中心",@"意见反馈",@"关于我们"];
    }
    return _titileArr;
}
-(NSArray *)iconArr{
    if (!_iconArr) {
        _iconArr = @[@"my_cont_wallet",@"my_cont_record",@"my_cont_red packe",@"my_cont_news",@"my_cont_feedback",@"aboutUs"];
    }
    return _iconArr;
}
- (MBProgressHUD *)HUD{
    if (!_HUD) {
        MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:KeyWindow];
#warning 打断点会停
        [KeyWindow addSubview:hud];
        hud.labelText = @"努力上传中";
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.mode = MBProgressHUDModeIndeterminate;
        //hud.progress = 0;
        _HUD = hud;
    }
    return _HUD;
}
@end
